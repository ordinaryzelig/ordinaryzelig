require File.dirname(__FILE__) + '/../test_helper'

class AccountTest < Test::Unit::TestCase
  
  march_madness_fixtures
  
  defaults({:user_id => 3,
            :season_id => 2})
  
  def test_user_and_season
    account = test_new_with_default_attributes
    assert_equal User.find(defaults[:user_id]).id, account.user.id
    assert_equal Season.find(defaults[:season_id]).id, account.season.id
  end
  
  def test_user_accounts_for_season
    account = test_new_with_default_attributes
    assert_equal account.user.accounts.for_season(account.season), account
  end
  
end
