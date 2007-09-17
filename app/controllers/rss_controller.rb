class RssController < ApplicationController
  
  layout false
  
  def user_recents
    @user = User.find_by_secret_id(params[:id])
    @recents = remove_read_entities(@user.recents)
    headers['Content-Type'] = 'application/rss+xml'
  end
  
end
