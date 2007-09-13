class RssController < ApplicationController
  
  layout false
  session :off
  skip_after_filter :mark_requested_page
  
  def user_recents
    @user = User.find_by_id(params[:id])
    @recents = @user.recents
    @headers['Content-Type'] = 'application/rss+xml'
  end
  
end
