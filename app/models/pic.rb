=begin
for typical PoolUsers, this is their prediction.
for master PoolUsers, this is what really happened.
=end

class Pic < ActiveRecord::Base
  
  belongs_to :game
  belongs_to :bid
  belongs_to :pool_user
  
  def point_worth(scoring_system = nil)
    scoring_system ||= ScoringSystems::default
    scoring_system::point_worth(self)
  end
  
  # return the furthest round that this team goes.
  def furthest_round
    all_pics_with_same_bid = Pic.find(:all, :conditions => ["season_id = ? and bid_id = ? and pool_user_id = ?", *[game.season_id, bid_id, pool_user_id]], :include => {:game => :round})
    max_pic = all_pics_with_same_bid.max { |a, b| a.game.round.number <=> b.game.round.number }
    max_pic.game.round if max_pic
  end
  
  # return whether this pic still has a chance to advance to the next round.
  def still_alive?
    # if this pic even has a bid,
    if bid
      master_pic = PoolUser::master(game.season_id).pics.for_game game
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
          child_game.pic(pool_user.id).still_alive?
        else
          true
        end
      end
    else
      nil
    end
  end
  
  def master_pic
    game.pic(PoolUser::master(pool_user.season_id).id)
  end
  
  def is_correct?
    mp = master_pic
    if bid && mp.bid
      bid_id == mp.bid_id
    end
  end
  
  def is_upset?
    if bid && master_pic.bid
      if game.children.empty?
        opponent_bid = game.first_round_bids.detect { |b| b.id != bid_id }
      else
        opponent_bid = game.children.detect { |child| child.master_pic.bid_id != bid_id }.master_pic.bid
      end
      opponent_bid.seed < bid.seed
    end
  end
  
end