class UserController < ApplicationController
  
  before_filter :require_authentication, :except => [:register, :test]
  skip_after_filter :mark_requested_page, :only => [:register]
  
  def index
    redirect_to(:action => "profile", :id => logged_in_user.id)
  end
  
  # params
  #   id (user)
  def profile
    @user = User.find_exclusive params[:id]
    render_layout_only 'user not found' and return unless @user
    @page_title =  "profile - #{@user.display_name}"
    @recents = @user.recents if is_self_or_logged_in_as_admin?(@user)
  end
  
  def edit_profile
    @user = User.find_exclusive params[:id]
    unless @user && is_self_or_logged_in_as_admin?(@user)
      flash[:failure] = "user #{params[:id]} not found."
      redirect_to_last_marked_page_or_default
      Notifier.deliver_warning "#{logged_in_user.first_last_display} attempted to edit user #{params[:id]}"
      return
    end
    if request.post?
      if @user.update_attributes(params[:user])
        flash[:success] = "profile saved"
        redirect_to(:action => "profile", :id => @user.id)
      end
    end
  end
  
  # params
  #   id (user)
  def change_password
    @user = logged_in_user
    if request.post?
      if @user.change_password(params[:old_password], params[:new_password], params[:confirmation_password])
        flash[:success] = "password set."
        redirect_to(:action => "edit_profile", :id => @user.id)
      end
    end
  end
  
  # new user creates own user record.
  def register
    @user = params[:user] ? User.new_registrant(params[:user], params[:confirmation_password]) : User.new
    if request.post?
      if @user.save
        flash[:success] = "registration successful."
        logged_in(@user)
      end
    end
  end
  
  def friends
    @user = User.find_exclusive(params[:id])
    render_layout_only 'user not found' and return unless @user && (is_self?(@user) || @user.considers_friend?(logged_in_user) || logged_in_as_admin?)
  end
  
  def friends_to
    @user = User.find_exclusive(params[:id])
    if @user
      if is_self_or_logged_in_as_admin?(@user)
        @considering_friendships = @user.considering_friendships
        @hide_mutual_friends = "true" == params[:hide_mutual_friends]
        @considering_friendships.reject! { |considering_friendship| @user.friends.include?(considering_friendship.user) } if @hide_mutual_friends
      else
        @reason_not_visible = "sorry, this is private."
      end
      @page_title = "users who consider you their friend"
    else
      @reason_not_visible = "user not found."
    end
    flash.now[:failure] = @reason_not_visible if @reason_not_visible
  end
  
  def add_friend
    if request.xhr?
      friendship = Friendship.new(:user => logged_in_user, :friend_id => params[:id])
      friendship.save!
      render(:partial => "add_remove_friend", :locals => {:friend => friendship.friend})
    end
  end
  
  def remove_friend
    if request.xhr?
      if User.find_exclusive(params[:id])
        friendship = Friendship.find_by_user_id_and_friend_id(logged_in_user.id, params[:id])
        friendship.destroy if friendship
        render(:partial => "add_remove_friend", :locals => {:friend => friendship.friend})
      end
    end
  end
  
  def search
    if request.get?
      @search_text = params[:id]
      @users = User.search(@search_text) if @search_text
      @page_title = "user search"
    else
      redirect_to(:action => "search", :id => params[:search_text])
    end
  end
  
  def generate_secret_id
    if request.post?
      @user = User.find_exclusive(params[:id])
      @user.generate_secret_id
      flash[:success] = "your rss url has been changed. please update your bookmarks." and redirect_to :back if @user.save
    end
  end
  
end
