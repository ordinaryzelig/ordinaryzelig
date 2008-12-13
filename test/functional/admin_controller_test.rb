require File.dirname(__FILE__) + '/../test_helper'
require 'admin_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < ActionController::TestCase
  
  def setup
    @controller = AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  march_madness_fixtures
  
  # params[:tournament_starts_at] won't work in this post.
  # implement tournament_starts_at_str.
  # def test_create_new_season
  #   login(:admin)
  #   now = Time.now
  #   post :edit_season, :params => {:tournament_starts_at => now, :buy_in => 10, :max_num_brackets => 1}
  #   season = Season.find_by_tournament_starts_at(now)
  #   assert_not_nil season
  #   assert_redirected_to :action => :select_team_bids, :id => season.id
  # end
  
  def test_enter_pool
    login :admin
    season_id = 3
    user = User.create!({:first_name => 'john',
                         :last_name => 'doe',
                         :display_name => 'doej',
                         :email => 'doej@asdf.fds',
                         :unhashed_password => 'asdf'})
    post :enter_pool, {:season_id => 3, :id => user.id}
    assert_not_nil PoolUser.find_by_user_id_and_season_id(user.id, season_id)
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
