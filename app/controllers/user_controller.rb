class UserController < ApplicationController
  
  before_filter :require_authentication, :except => [:register, :test]
  skip_after_filter :mark_requested_page, :only => [:register]
  
  def index
    redirect_to(:action => "profile", :id => logged_in_user.id)
  end
  
  def profile
    @user = User.find_non_admin :first, params[:id]
    render_layout_only 'user not found' and return unless @user
    @page_title =  "profile - #{@user.display_name}"
    @recents = @user.recents if is_self_or_logged_in_as_admin?(@user)
  end
  
  def edit_profile
    @user = User.find_non_admin :first, params[:id]
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
  
  def change_password
    @user = logged_in_user
    if request.post?
      if @user.change_password(params[:old_password], params[:new_password], params[:confirmation_password])
        flash[:success] = "password set."
        redirect_to(:action => "edit_profile", :id => @user.id)
      end
    end
  end
  
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
    @user = User.find_non_admin :first, params[:id])
    render_layout_only 'user not found' and return unless @user
    render_layout_only 'this is private.' and return unless logged_in_user && @user.considers_friend?(logged_in_user)
    @page_title = "#{@user.display_name}'s friends"
  end
  
  def friends_to
    @hide_mutual_friends = 'true' == params[:hide_mutual_friends]
    @page_title = "people who consider you their friend"
  end
  
  def add_friend
    if request.xhr?
      friendship = Friendship.new
      friendship.user = logged_in_user
      friendship.friend_id = params[:id].to_s
      friendship.save!
      render(:partial => "add_remove_friend", :locals => {:friend => friendship.friend})
    end
  end
  
  def remove_friend
    if request.xhr?
      if User.find_non_admin :first, params[:id]
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
      @user = User.find_non_admin :first, params[:id]
      @user.generate_secret_id
      flash[:success] = "your rss url has been changed. please update your bookmarks." and redirect_to :back if @user.save
    end
  end
  
  def blogs
    redirect_to :controller => 'blog', :action => 'list', :id => params[:id]
  end
  
end
