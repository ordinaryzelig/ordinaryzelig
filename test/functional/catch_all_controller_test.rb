require File.dirname(__FILE__) + '/../test_helper'
require 'catch_all_controller'

# Re-raise errors caught by the controller.
class CatchAllController; def rescue_action(e) raise e end; end

class CatchAllControllerTest < Test::Unit::TestCase
  def setup
    @controller = CatchAllController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
