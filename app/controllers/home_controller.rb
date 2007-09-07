class HomeController < ApplicationController
  
  skip_after_filter :mark_requested_page
  
  def test
    raise 'send mail'
  end
  
end
