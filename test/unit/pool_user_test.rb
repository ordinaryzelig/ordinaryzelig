require File.dirname(__FILE__) + '/../test_helper'

class PoolUserTest < Test::Unit::TestCase
  
  fixtures :pool_users
  
  defaults({:season_id => 1,
            :user_id => 3})
  
  def test_master
    master_pool_user = PoolUser.find(:first, :conditions => 'season_id = 1 and user_id = 1')
    assert_equal PoolUser.master(Season.find(1)), master_pool_user
  end
  
  def test_points
    pool_user = pool_users(:cece_winner)
    master_pics = pool_user.class.master(pool_user.season).pics
    {ScoringSystems::Jared => 235,
     ScoringSystems::Cbs => 63,
     ScoringSystems::Espn => 630,
     ScoringSystems::SportsIllustrated => 70}.each do |system, points|
       assert_equal pool_user.calculate_points(master_pics, system), points
    end
  end
  
  def test_bracket_complete
    pool_user = pool_users(:cece_winner)
    assert pool_user.bracket_complete?
    # test when one pic is blank.
    pic = pool_user.pics.for_game(pool_user.season.root_game)
    bid_id = pic.bid_id
    pic.bid_id = nil
    pic.save
    assert_not pool_user.bracket_complete?
    # put it back and test again.
    pic.bid_id = bid_id
    pic.save
    assert pool_user.bracket_complete?
  end
  
  def test_pics_left
    pool_user = pool_users(:john_2007)
    assert_equal 0, pool_user.pics_left.size
    # test when championship game has not yet been decided.
    master_pool_user = pool_user.class.master(pool_user.season)
    master_pic = master_pool_user.pics.for_game(pool_user.season.root_game)
    bid_id = master_pic.bid_id
    master_pic.bid_id = nil
    master_pic.save
    assert_not master_pool_user.bracket_complete?
    assert_equal 1, pool_user.pics_left.size
  end
  
  def test_points_left
    # same as test_pics_left, but with points.
  end
  
  def test_unique_points
    
  end
  
end
