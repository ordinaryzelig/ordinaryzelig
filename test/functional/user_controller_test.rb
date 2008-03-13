require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'

# Re-raise errors caught by the controller.
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  
  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_registration
    display_name = 'john doe'
    assert_nil User.find_by_display_name(display_name)
    post :register, {:user => {:email => 'asdf@asdf.asdf',
                               :first_name => 'john',
                               :last_name => 'doe',
                               :display_name => display_name,
                               :password => 'asdf',
                               :password => 'asdf'}}
    assert_not_nil User.find_by_display_name(display_name)
  end
  
end
