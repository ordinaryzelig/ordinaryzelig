require File.dirname(__FILE__) + '/../test_helper'

class PoolUserTest < Test::Unit::TestCase
  
  march_madness_fixtures
  
  defaults({:season_id => 1,
            :user_id => 3,
            :bracket_num => 1})
  
  def test_master
    master_pool_user = PoolUser.find(:first, :conditions => 'season_id = 1 and user_id = 1')
    assert_equal PoolUser.master(Season.find(1)), master_pool_user
  end
  
  def test_points
    pool_user = pool_users(:cece_winner)
    master_pics = pool_user.class.master(pool_user.season).pics
    {ScoringSystems::Jared => 235,
     ScoringSystems::Cbs => 126,
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
    assert_save master_pic
    assert_not master_pool_user.bracket_complete?
    assert_equal 1, pool_user.pics_left.size
  end
  
  def test_points_left
    # same as test_pics_left, but with points.
  end
  
  def test_unique_points
    
  end
  
  def test_makes_pics
    pool_user = test_new_with_default_attributes
    assert_equal 63, pool_user.pics.size
  end
  
  def test_user_account
    pool_user = test_new_with_default_attributes
    accounts = pool_user.user.accounts
    assert_not accounts.empty?
    assert_not_nil accounts.for_season(pool_user.season)
  end
  
  def test_user_pool_users_for_season
    user = users :ten_cent
    season = seasons :_2007
    user_pool_users = user.pool_users.for_season(season)
    user_pool_users.each do |pool_user|
      assert_equal season, pool_user.season
      assert_equal user, pool_user.user
    end
    PoolUser.find_all_by_season_id_and_user_id(season.id, user.id).each do |pool_user|
      assert user_pool_users.include?(pool_user)
    end
    user_pool_users
  end
  
  def test_user_pool_users_for_season_and_bracket_num
    user = users :ten_cent
    season = seasons :_2007
    bracket_num = 1
    assert_equal PoolUser.find_by_season_id_and_user_id_and_bracket_num(season.id, user.id, bracket_num).id, user.pool_users.for_season_and_bracket_num(season, bracket_num).id
  end
  
end
