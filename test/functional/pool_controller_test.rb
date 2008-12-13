require File.dirname(__FILE__) + '/../test_helper'
require 'pool_controller'

# Re-raise errors caught by the controller.
class PoolController; def rescue_action(e) raise e end; end

class PoolControllerTest < ActionController::TestCase
  
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
  
  # def test_season_not_found
  #   ['sdf', Season.calculate(:max, :id) + 1].each do |param|
  #     assert_raise(FriendlyError, "season: #{param} did not raise FriendlyError.") { get(:standings, {:season_id => param}) }
  #   end
  # end
  
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
  
  def test_user_not_participating
    season = seasons :_2007
    user = users(:Surly_Stuka)
    assert_raise(FriendlyError) { get :bracket, {:id => user.id} }
  end
  
  def test_master_bracket_always_open
    season = seasons :_2007
    season.update_attribute(:tournament_starts_at, 1.day.from_now)
    assert_not season.tournament_has_started?
    assert_get_bracket User.master_id, season.id, true
    season
  end
  
  def test_selection_sunday_open_to_self_and_master_bracket_only
    season = test_master_bracket_always_open
    user_fixture = :ten_cent
    user = users user_fixture
    assert_get_bracket user.id, season.id, false
    login user_fixture
    assert_get_bracket user.id, season.id, true
  end
  
  def assert_get_bracket(user_id, season_id, success_expected)
    begin
      get :bracket, {:id => user_id, :season_id => season_id}
      success_expected ? assert_response_true_success : flunk
    rescue FriendlyError => fe
      assert fe.msg =~ /brackets are private until the tournament starts/
    end
  end
  
  # def test_making_pics_allowed_by_user
  #   user_fixture = :ten_cent
  #   user = users user_fixture
  #   season = seasons(:_2007)
  #   pool_user = user.pool_users.for_season(season).first
  #   assert_equal user.id, pool_user.user_id
  #   game = season.regions.final_4.championship_game
  #   pic = pool_user.pics.for_game(game)
  #   bid = pic.bid
  #   # time to make pics has passed.
  #   assert season.tournament_has_started?
  #   [[nil, false],
  #    [user_fixture, false],
  #    [:cecelia, false],
  #    [:admin, true]].each { |fixture, allowed| assert_can_make_pics? pool_user, bid, game, fixture, allowed }
  #   season.update_attribute(:tournament_starts_at, 1.day.from_now)
  #   assert_not season.tournament_has_started?
  #   [[nil, false],
  #    [user_fixture, true],
  #    [:cecelia, false],
  #    [:admin, true]].each { |fixture, allowed| assert_can_make_pics? pool_user, bid, game, fixture, allowed }
  # end
  
  def assert_can_make_pics?(pool_user, bid, game, user_fixture, allowed)
    user = login(user_fixture) if user_fixture
    logged_in = !user.nil?
    begin
      puts [pool_user.id, game.id, bid.id].join(":")
      post :make_pic, {:pool_user_id => pool_user.id, :game_id => game.id, :bid_id => bid.id}
      assert_redirected_to :action => 'bracket', :season_id => game.season_id, :id => pool_user.user_id, :region_order => (game.parent ? game.parent.region.order_num : game.region.order_num), :bracket_num => pool_user.bracket_num
    rescue Exception => e
      unless logged_in
        assert_template nil
        return 
      end
      if allowed
        raise # something else wrong.
      else
        assert_match /trying to edit/, e.message
      end
    end
    reset_controller
  end
  
end
