require File.dirname(__FILE__) + '/../test_helper'
require 'message_board_controller'

# Re-raise errors caught by the controller.
class MessageBoardController; def rescue_action(e) raise e end; end

class MessageBoardControllerTest < Test::Unit::TestCase
  def setup
    @controller = MessageBoardController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
