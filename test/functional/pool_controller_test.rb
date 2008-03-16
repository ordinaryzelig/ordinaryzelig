require File.dirname(__FILE__) + '/../test_helper'
require 'pool_controller'

# Re-raise errors caught by the controller.
class PoolController; def rescue_action(e) raise e end; end

class PoolControllerTest < Test::Unit::TestCase
  
  def setup
    @controller = PoolController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  march_madness_fixtures
  
  def test_bracket
    user = users :ten_cent
    season = seasons :_2007
    [nil, {:region_order => 1}].inject({:id => user.id, :season_id => season.id}) do |parameters, param|
      parameters.update param if param
      get :bracket, parameters.dup
      assert_response_true_success
      parameters
    end
  end
  
  def test_no_season_given
    get :standings
    assert_equal seasons(:_2007).year, assigns('season').year
  end
  
  def test_standings
    [nil, Season.find(:all)].each do |season|
      get :standings, {:season_id => season}
      assert_response_true_success
    end
  end
  
  def test_season_not_found
    ['sdf', Season.calculate(:max, :id) + 1].each do |param|
      assert_raise(FriendlyError) { get(:standings, {:season_id => param}) }
    end
  end
  
  def test_game_pics
    get :game_pics, {:id => games(:george_mason_first_game).id}
  end
  
  def test_pvp
    pool_user = users(:ten_cent).pool_users.first
    post :pvp, {:pool_user_id => pool_user.id, :other_pool_user_ids => pool_user.season.pool_users.non_admin}
    assert_response_true_success
  end
  
  def test_printable_bracket
    user = users :ten_cent
    season = seasons :_2007
    get :printable_bracket, {:id => user.id, :season_id => season.id}
  end
  
end
