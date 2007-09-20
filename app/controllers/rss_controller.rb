class RssController < ApplicationController
  
  layout false
  session false
  
  def user_recents
    @user = User.find_by_secret_id(params[:id])
    render(:nothing => true) and return unless @user
    @recents = remove_read_entities(@user.recents)
    headers['Content-Type'] = 'application/rss+xml'
  end
  
end
