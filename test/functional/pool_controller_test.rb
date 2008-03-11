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
  
end
