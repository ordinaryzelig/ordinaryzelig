require File.dirname(__FILE__) + '/../test_helper'

class AccountTest < ActiveSupport::TestCase
  
  fixtures :seasons, :users, :accounts, :pool_users
  
  defaults
  
  def test_user_and_season
    account = test_new_with_default_attributes
    assert_equal User.find(account[:user_id]).id, account.user.id
    assert_equal Season.find(account[:season_id]).id, account.season.id
  end
  
  def test_user_accounts_for_season
    account = test_new_with_default_attributes
    assert_equal account.user.accounts.for_season(account.season), account
  end
  
  def test_pay
    pay :ten_cent_2005, 10
    pay :ten_cent_2006, 20
  end
  
  test_fixture_associations :season, :user, &:id
  
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
  
  class_eval do
    # there are accounts for everybody.  destroy new one before using.
    def new_with_default_attributes_with_destroy(*atts)
      obj = new_with_default_attributes_without_destroy *atts
      Account.find_by_user_id_and_season_id(obj.user_id, obj.season_id).destroy
      obj
    end
    alias_method_chain :new_with_default_attributes, :destroy
  end
  
end
