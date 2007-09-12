class LoginController < ApplicationController
  
  skip_after_filter :mark_requested_page
  
  def index
    flash.keep
    redirect_to(:action => "login")
  end
  
  def login
    if request.get?
      @user = User.new
    else
      @user = User.new(params[:user])
      params[:user] = nil # just in case.
      authenticated_user = @user.authenticate
      if authenticated_user
        logged_in(authenticated_user)
      end
    end
  end
  
  def logout
    flash[:notice] = "logged out." if logged_in_user
    reset_session
    redirect_to :action => "index"
  end
  
end