require File.dirname(__FILE__) + '/../test_helper'

class MessageBoardControllerTest < ActionController::TestCase
  
  fixtures FIXTURES[:user]
  fixtures :messages
  
end
