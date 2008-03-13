class HomeController < ApplicationController
  
  skip_after_filter :mark_requested_page
  
  def welcome
    render :footnotes => false
  end
  
end
