require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  
  fixtures FIXTURES[:user]
  
  def test_deliver_exception
    user = users(:ten_cent)
    request = StubbedRequest.new('/admin/restricted_action', 'post')
    ex = Exception.new
    ex.set_backtrace %w[1 2 3 4]
    assert Notifier.deliver_exception(ex, user, request)
  end
  
end

class StubbedRequest
  attr_accessor :request_uri, :method
  def initialize(request_uri, method)
    @request_uri, @method = request_uri, method
  end
end
