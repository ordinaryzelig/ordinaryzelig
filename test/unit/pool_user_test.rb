require File.dirname(__FILE__) + '/../test_helper'

class PoolUserTest < Test::Unit::TestCase
  
  fixtures :pool_users
  
  defaults({:season_id => 1,
            :user_id => 3})
  
  def test_master
    master_pool_user = PoolUser.find(:first, :conditions => 'season_id = 1 and user_id = 1')
    assert_equal PoolUser.master(Season.find(1)), master_pool_user
  end
  
  
  
end
