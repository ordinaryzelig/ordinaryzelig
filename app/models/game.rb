class Game < ActiveRecord::Base
  
  acts_as_tree :order => :id
  belongs_to :round
  belongs_to :season
  belongs_to :region
  has_many :first_round_bids, :class_name => "Bid", :foreign_key => "first_game_id", :order => "seed"
  has_many :pics do
    def master
      detect { |pic| pic.pool_user.user_id == User.master_id }
    end
  end
  
  def self.new_season(season)
    championship_game = new :round_id => 1, :region => season.regions[0]
    championship_game.season = season
    # create final four games and their children (regional championship games).
    new_tree(championship_game, 2)
    regional_championship_games = [championship_game.top.top, championship_game.top.bottom, championship_game.bottom.top, championship_game.bottom.bottom]
    # create region brackets.
    regional_championship_games.each_with_index do |game, i|
      game.region = season.regions[i + 1]
      new_tree(game, 3)
    end
    championship_game.save!
  end
  
  # create a new tree with given number of rounds.
  def self.new_tree(parent, rounds)
    return unless 0 < rounds
    2.times do
      child = new :round_id => parent.round_id + 1,
                  :season_id => parent.season_id,
                  :region_id => parent.region_id
      parent.children << child
      # recurse.
      new_tree(child, rounds - 1)
    end
  end
  private_class_method :new_tree
  
  # pool_user chooses this bid to win.
  # find and save the pic.
  # return other pics that are affected.
  def declare_winner(bid, pool_user)
    raise 'illegal pic' unless participating_bids(pool_user).include?(bid)
    pic = pool_user.pics.for_game self
    old_bid_id = pic.bid_id
    pic.bid_id = bid.id
    pic.save!
    other_pics_affected = parent.stop_progress_of_bid(old_bid_id, pool_user) if parent && old_bid_id && old_bid_id != bid.id
    other_pics_affected || []
  end
  
  # bid_id should not be winner of this or any parent games.
  def stop_progress_of_bid(old_bid_id, pool_user)
    pic = pool_user.pics.for_game self
    other_pics_affected = []
    if old_bid_id == pic.bid_id
      pic.bid_id = nil
      pic.save
      other_pics_affected << pic
      # recurse.
      other_pics_affected += self.parent.stop_progress_of_bid(old_bid_id, pool_user) if self.parent      
    end
    other_pics_affected
  end
  
  # return the game where this pic had to win to get here.
  def child_with_pic(pic)
    children.detect { |game| pic.pool_user.pics.for_game(game).bid_id == pic.bid_id }
  end
  
  def game_in_lineage_with_pic(pic, round_number)
    if round.number == round_number
      self
    else
      if round_number < round.number
        cwp = child_with_pic(pic)
        cwp.game_in_lineage_with_pic(pic, round_number) if cwp
      else
        parent.game_in_lineage_with_pic(pic, round_number)
      end
    end
  end
  
  def top
    self.children[0]
  end
  
  def bottom
    self.children[1]
  end
  
  def top?
    return unless parent
    parent.top == self
  end
  
  def bottom?
    return unless parent
    parent.bottom? == self
  end
  
  def left_or_right
    case top?
    when true
      'left'
    when false
      'right'
    else
      nil
    end
  end
  
  # for caching.
  def load_children
    children.each &:load_children
  end
  
  def self.root_for_season(season)
    Game.find(:first, :conditions => {:season_id => season.id, :parent_id => nil})
  end
  
  def participating_bids(pool_user)
    if children.empty?
      first_round_bids
    else
      children.map { |game| pool_user.pics.for_game(game).bid }
    end
  end
  
  def is_championship_game?
    parent.nil? || region.order_num != parent.region.order_num
  end
  
end
