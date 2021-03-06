require File.dirname(__FILE__) + '/../test_helper'

class AdminControllerTest < ActionController::TestCase
  
  fixtures FIXTURES[:user]
  fixtures FIXTURES[:march_madness]
  
  # params[:tournament_starts_at] won't work in this post.
  # implement tournament_starts_at_str.
  def test_create_new_season
    login(:admin)
    now = Time.now
    post :edit_season, :season => {:tournament_starts_at => now, :buy_in => 10, :max_num_brackets => 1}
    season = Season.find_by_year(now.year)
    assert_not_nil season
    assert_redirected_to :action => :select_team_bids, :id => season.id
  end
  
  def test_enter_pool
    login :admin
    season = seasons :_2007
    user = User.create!({:first_name => 'john',
                         :last_name => 'doe',
                         :display_name => 'doej',
                         :email => 'doej@asdf.fds',
                         :unhashed_password => 'asdf'})
    post :enter_pool, {:season_id => season.id, :id => user.id}
    assert_not_nil PoolUser.find_by_user_id_and_season_id(user.id, season.id)
  end
  
  def test_pay
    login :admin
    account = accounts :ten_cent_2007
    account.update_attribute :amount_paid, 0
    assert_equal 0, account.amount_paid
    post :pay, {:id => account.user.id, :season_id => account.season.id}
    assert_equal 10, account.reload.amount_paid
  end
  
  def test_non_admin
    login :ten_cent
    AdminController.action_methods.each do |action|
      put action
      assert_equal ApplicationController::PAGE_DOES_NOT_EXIST, @response.flash[:failure]
    end
  end
  
end
