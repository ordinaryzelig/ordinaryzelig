class UserController < ApplicationController
  
  before_filter :validate_session, :except => [:register, :test]
  skip_after_filter :mark_requested_page, :only => [:register]
  
  ADMIN_ACTIONS = ["new"]
  
  def index
    redirect_to(:action => "profile", :id => logged_in_user.id)
  end
  
  # params
  #   id (user)
  def profile
    @user = User.find_by_id(params[:id])
    if @user && !@user.is_admin_or_master?
      @page_title =  "profile - #{@user.display_name}"
      if is_self?(@user)
        @recents = @user.recents 
        # if it's a comment, check to see if it will be included with a recent object's summarize_recent_comments.
        @recents.select { |ent| ent.is_a?(Comment) }.each do |comment|
          @recents.delete_if { |ent| !ent.is_a?(Comment) && ent.class.can_have_comments? && ent.summarize_recent_comments(logged_in_user).include?(comment) }
        end
        read_entities = logged_in_user.read_items.entities
        @recents.delete_if { |ent| read_entities.include?(ent) }
        # if it's a comment, store the entity
        @recents = @recents.map { |ent| ent.class == Comment ? ent.entity : ent }
        # in case there are multiple comments for an object, list it only once.
        @recents = @recents.uniq
      end
    else
      @reason_not_visible = "user not found"
      flash.now[:failure] = @reason_not_visible
      render :nothing => true, :layout => true
    end
  end
  
  def edit_profile
    if request.get?
      @user = User.find_by_id(params[:id])
      unless @user && is_self_or_admin?(@user) && !@user.is_admin_or_master?
        flash[:failure] = "user not found."
        logger.warn "user #{logged_in_user.id} attempted to edit user #{params[:id]}"
        redirect_to_last_marked_page_or_default
        return
      end
    else
    # post.
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
        flash[:success] = "profile saved"
        redirect_to(:action => "profile", :id => @user.id)
      end
    end
  end
  
  # params
  #   id (user)
  def set_password
    if request.get?
      @user = User.find_by_id(params[:id])
      unless @user && is_self_or_admin?(@user)
        flash[:failure] = "user not found."
        logger.warn "user #{logged_in_user.id} tried to set password for user #{params[:id]}"
        redirect_to_last_marked_page_or_default
      end
      @user_with_new_password = User.new
    else
      @user = User.new(params[:user])
      @user_with_new_password = User.new(params[:user_with_new_password])
      params[:user] = nil # just in case.
      params[:user_with_new_password] = nil # just in case.
      # unless admin, authenticate before setting password.
      # else, admin can just set it and forget it.
      if logged_in_user.is_admin?
        user_to_set_new_password_on = User.find(params[:id])
      else
        user_to_set_new_password_on = @user.authenticate
      end
      if user_to_set_new_password_on
        user_to_set_new_password_on.unhashed_password = @user_with_new_password.unhashed_password
        user_to_set_new_password_on.confirmation_password = @user_with_new_password.confirmation_password
        user_to_set_new_password_on.needs_password_confirmation = true
        user_to_set_new_password_on.validate_set_new_password
        if user_to_set_new_password_on.errors.empty? && user_to_set_new_password_on.save
          flash[:success] = "password set."
          redirect_to(:action => "edit_profile", :id => user_to_set_new_password_on.id)
        else
          @user = user_to_set_new_password_on
        end
      end
      # else, render with errors.
    end
  end
  
  # new user creates own user record.
  def register
    if request.get?
      @user = User.new
    else
    # post.
      @user = User.new(params[:user])
      params[:user] = nil # just in case.
      @user.needs_password_confirmation = true
      if @user.save
        flash[:success] = "registration successful."
        logged_in(@user)
      end
    end
  end
  
  def new
    if request.get?
      @user = User.new
    else
    # post.
      @user = User.new(params[:user])
      if @user.save
        flash[:success] = "user #{@user.id} created."
        redirect_to(:controller => "admin", :action => "users")
      end
    end
  end
  
  def friends
    @user = User.find_by_id(params[:id])
    if @user && !@user.is_admin_or_master?
      if is_self?(@user) || @user.considers_friend?(logged_in_user)
        @page_title = "#{@user.display_name} friends"
      else
        @reason_not_visible = "sorry, this is private."
      end
    else
      @reason_not_visible = "user not found."
    end
    flash.now[:failure] = @reason_not_visible if @reason_not_visible
  end
  
  def friends_to
    @user = User.find_by_id(params[:id])
    if @user && !@user.is_admin_or_master?
      if is_self_or_admin?(@user)
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
      @user = User.find_by_id(params[:id])
      if @user && !@user.is_admin_or_master?
        friendship = Friendship.new(:user => logged_in_user, :friend_id => params[:id])
        if friendship.save
          render(:partial => "add_remove_friend", :locals => {:friend => friendship.friend})
        else
          render(:text => "there was an error adding your friend.")
          logger.error "error saving friendship #{friendship.inspect}."
        end
      end
    end
  end
  
  def remove_friend
    if request.xhr?
      if User.find_by_id(params[:id])
        friendship = Friendship.find_by_user_id_and_friend_id(logged_in_user.id, params[:id])
        friendship.destroy if friendship
        render(:partial => "add_remove_friend", :locals => {:friend => friendship.friend})
      end
    end
  end
  
  def search
    if request.get?
      @search_text = params[:id]
      if @search_text
        if @search_text.length >= 3
          @users = User.search(@search_text)
          @users.reject! { |user| user.is_admin_or_master? }
          @search_text_valid = true
        else
          flash.now[:failure] = "search for at least 3 characters."
        end
      end
      @page_title = "user search"
    else
      redirect_to(:action => "search", :id => params[:search_text])
    end
  end
  
  def generate_secret_id
    if request.post?
      @user = User.find_by_id(params[:id])
      @user.generate_secret_id
      flash[:success] = "your rss url has been changed. please update your bookmarks." and redirect_to :back if @user.save
    end
  end
  
end
