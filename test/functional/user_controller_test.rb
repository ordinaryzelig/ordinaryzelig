require File.dirname(__FILE__) + '/../test_helper'

class UserControllerTest < ActionController::TestCase
  
  fixtures :all
  
  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_register
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
  
  def test_profile
    user = login :ten_cent
    get :profile, :id => user.to_param
    assert_equal user.id, assigns('user').id
    recents = assigns('recents')
    assert recents.size > 0, 'no recents found.'
    recents.each do |r|
      assert r.is_recent_to?(user)
    end
  end
  
end
