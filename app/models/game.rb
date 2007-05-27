=begin
a game for a season.
=end

class Game < ActiveRecord::Base
  
  acts_as_tree
  belongs_to :round
  belongs_to :season
  has_many :first_round_bids, :class_name => "Bid", :foreign_key => "first_game_id", :order => "seed"
  has_many :pics
  belongs_to :region
  
  # create new bracket for a season.
  def Game::new_season(season)
    championshipGame = Game.new(:round_id => 1, :region => season.regions[0])
    championshipGame.season = season
    # create final four games and their children (regional championship games).
    Game::new_tree(championshipGame, 2)
    regional_championship_games = [championshipGame.top.top, championshipGame.top.bottom, championshipGame.bottom.top, championshipGame.bottom.bottom]
    # create region brackets.
    regional_championship_games.each_with_index do |game, i|
      game.region = season.regions[i + 1]
      Game::new_tree(game, 3)
    end
    championshipGame.save
  end
  
  # create a new tree with given number of rounds.
  def Game::new_tree(parent, rounds)
    if 0 < rounds
      0.upto(1) do |i|
        # create child game.
        parent.children.create(:round_id => parent.round_id + 1)
        parent.children[i].season = parent.season
        parent.children[i].region = parent.region
        # recurse.
        Game::new_tree(parent.children[i], rounds - 1)
      end
    end
  end
  
  def declare_winner(bid, pool_user_id)
    pic = pic(pool_user_id)
    old_bid_id = pic.bid_id
    pic.bid_id = bid.id
    pic.save
    other_pics_affected = parent.stop_progress_of_bid(old_bid_id, pool_user_id) if parent && old_bid_id && old_bid_id != bid.id
    other_pics_affected || []
  end
  
  # bid_id should not be winner of this or any parent games.
  def stop_progress_of_bid(old_bid_id, pool_user_id)
    pic = pic(pool_user_id)
    other_pics_affected = []
    if old_bid_id == pic.bid_id
      pic.bid_id = nil
      pic.save
      other_pics_affected << pic
      # recurse.
      other_pics_affected += self.parent.stop_progress_of_bid(old_bid_id, pool_user_id) if self.parent      
    end
    other_pics_affected
  end
  
  def pic(pool_user_id)
    pics.detect{|pic| pool_user_id == pic.pool_user_id}
  end
  
  def child_with_pic(pic)
    children.detect{|game| game.pic(pic.pool_user.id).bid_id == pic.bid_id}
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
  
  # return the top game.
  def top
    self.children[0]
  end
  
  # return the bottom game.
  def bottom
    self.children[1]
  end
  
  def master_pic
    pics.detect do |pic|
      pic.pool_user.user_id == User::master_id
    end
  end
  
  # return array of games that have not yet been decided.
  def self.undecided(season_id)
    games = find(:all, :conditions => ["#{table_name}.season_id = ?", season_id], :include => {:pics => [:pool_user, :bid]})
    master_pool_user = PoolUser::master(season_id)
    games.reject { |game| game.pic(master_pool_user.id).bid }
  end
  
end