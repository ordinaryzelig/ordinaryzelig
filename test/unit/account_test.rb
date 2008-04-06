require File.dirname(__FILE__) + '/../test_helper'

class AccountTest < Test::Unit::TestCase
  
  march_madness_fixtures
  
  defaults({:user_id => Fixtures.identify(:cecelia),
            :season_id => 3})
  
  def test_user_and_season
    account = test_new_with_default_attributes
    assert_equal User.find(defaults[:user_id]).id, account.user.id
    assert_equal Season.find(defaults[:season_id]).id, account.season.id
  end
  
  def test_user_accounts_for_season
    account = test_new_with_default_attributes
    assert_equal account.user.accounts.for_season(account.season), account
  end
  
  def test_pay
    pay :ten_cent_2005, 10
    pay :ten_cent_2006, 20
  end
  
  # =====================================================
  # helpers.
  
  def pay(user_account_fixture, amount_paid_expected)
    account = accounts user_account_fixture
    assert account.user.pool_users.for_season(account.season).size > 0
    account.update_attribute :amount_paid, 0
    assert_equal 0, account.amount_paid
    account.pay
    assert_equal amount_paid_expected, account.amount_paid
  end
  
end
