require File.dirname(__FILE__) + '/../test_helper'
require 'admin_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase
  
  def setup
    @controller = AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  # def test_create_new_season
  #   login(:admin)
  #   now = Time.now
  #   post :edit_season, :params => {:tournament_starts_at => now, :buy_in => 10, :max_num_brackets => 1}
  #   season = Season.find_by_tournament_starts_at(now)
  #   assert_not_nil season
  #   assert_redirected_to :action => :select_team_bids, :id => season.id
  # end
  
end
