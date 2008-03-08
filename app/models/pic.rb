=begin
for typical PoolUsers, this is their prediction.
for master PoolUsers, this is what really happened.
=end

class Pic < ActiveRecord::Base
  
  belongs_to :game
  belongs_to :bid
  belongs_to :pool_user
  
  scope_out :incomplete, :conditions => 'bid_id is null'
  
  def point_worth(scoring_system = ScoringSystems.default)
    scoring_system.point_worth(self)
  end
  
  # return the furthest round that this team goes.
  def furthest_round_won_number
    Pic.calculate(:max, "number",
                  :conditions => ["season_id = ? and " <<
                                  "bid_id = ? and " <<
                                  "pool_user_id = ?",
                                  game.season_id, bid_id, pool_user_id],
                  :include => {:game => :round}).to_i
  end
  
  # return whether this pic still has a chance to advance to the next round.
  def still_alive?
    return false unless bid_id
    # if this pic even has a bid,
    master_pic = PoolUser.master(game.season).pics.for_game game
    if master_pic.bid_id
      # if master_pic for same game has a bid,
      if master_pic.bid_id == bid_id
        true
      else
        false
      end
    else
      child_game = game.child_with_pic(self)
      if child_game
        pool_user.pics.for_game(child_game).still_alive?
      else
        true
      end
    end
  end
  
  def master_pic
    @master_pic ||= PoolUser.master(pool_user.season).pics.for_game(game)
  end
  
  def is_correct?
    return @is_correct if @is_correct
    if bid && master_pic.bid
      @is_correct = bid_id == master_pic.bid_id
    end
  end
  
  def is_upset?
    if bid && master_pic.bid
      if game.children.empty?
        opponent_bid = game.first_round_bids.detect { |b| b.id != bid_id }
      else
        opponent_bid = game.children.detect { |child| child.pics.master.bid_id != bid_id }.pics.master.bid
      end
      opponent_bid.seed < bid.seed
    end
  end
  
end
