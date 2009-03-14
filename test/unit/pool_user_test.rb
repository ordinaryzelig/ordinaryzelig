require File.dirname(__FILE__) + '/../test_helper'

class PoolUserTest < ActiveSupport::TestCase
  
  fixtures FIXTURES[:user]
  fixtures FIXTURES[:march_madness]
  
  defaults
  
  def test_master
    assert_equal 'master bracket', PoolUser.master(seasons(:_2005)).user.display_name
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
    assert_nil master_pic.bid_id
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
  
  def test_is_master?
    assert users(:master_bracket).pool_users.first.is_master?
    assert_not users(:ten_cent).pool_users.first.is_master?
  end
  
  def test_is_editable_by?
    pool_user = pool_users :cece_winner
    # season has already started by now.
    assert_pool_user_editable_by? pool_user, nil, false
    assert_pool_user_editable_by? pool_user, :ten_cent, false
    assert_pool_user_editable_by? pool_user, :the_prophet, false
    assert_pool_user_editable_by? pool_user, :admin, true
    # now try when tournament has started.
    pool_user.season.update_attribute(:tournament_starts_at, 1.day.from_now)
    assert_not pool_user.season.tournament_has_started?
    assert_pool_user_editable_by? pool_user, :ten_cent, false
    assert_pool_user_editable_by? pool_user, :the_prophet, true
    assert_pool_user_editable_by? pool_user, :admin, true
  end
  
  def assert_pool_user_editable_by?(pool_user, user_fixture, expected_to_be_editale)
    user = user_fixture ? users(user_fixture) : nil
    result = pool_user.is_editable_by? user
    expected_to_be_editale ? assert(result) : assert_not(result)
  end
  
  test_fixture_associations :season
  
end
