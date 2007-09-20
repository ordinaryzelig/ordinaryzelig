class RssController < ApplicationController
  
  layout false
  session false
  
  def user_recents
    @user = User.find_by_secret_id(params[:id])
    render(:nothing => true) and return unless @user
    @recents = @user.recents
    headers['Content-Type'] = 'application/rss+xml'
  end
  
end
