class BlogController < ApplicationController
  
  before_filter :validate_session
  
  def list
    @user = User.find_by_id(params[:id], :include => :blogs, :order => "created_at desc")
    if @user
      @reason_not_visible = "you must be this person's friend to view their blogs." unless @user.considers_friend?(logged_in_user) || is_self_or_admin?(@user)
    else
      @reason_not_visible = "user not found."
    end
    flash.now[:failure] = @reason_not_visible if @reason_not_visible
    @page_title = "blog - #{@user.display_name}" if @user
  end
  
  def show
    @blog = Blog.find_by_id(params[:id], :include => :user)
    if @blog
      unless is_self_or_admin?(@blog.user) || @blog.user.considers_friend?(logged_in_user)
        @reason_not_visible = "this blog is private."
      end
    else
      @reason_not_visible = "blog not found."
    end
    flash.now[:failure] = @reason_not_visible if @reason_not_visible
    @page_title = "blog - #{@blog.user.display_name} - #{@blog.title}" unless @reason_not_visible
  end
  
  def new
    if request.get?
      @blog = Blog.new
    else
      @blog = Blog.new(params[:blog])
      @blog.user ||= logged_in_user
      if @blog.save
        flash[:success] = "blog created."
        redirect_to(:action => "view", :id => @blog.id)
      end
    end
  end
  
  def preview
    if request.xhr?
      @blog = Blog.new(params[:blog])
    end
    render(:layout => false)
  end
  
  def edit
    @blog = Blog.find_by_id(params[:id])
    if request.get?
      if @blog
        unless is_self_or_admin?(@blog.user)
          @reason_not_visible = "this blog is private."
          logger.warn "user #{logged_in_user.id} tried to edit blog #{params[:id]}."
        end
      else
        @reason_not_visible = "blog not found."
      end
      flash.now[:failure] = @reason_not_visible if @reason_not_visible
    else
      if @blog.update_attributes(params[:blog])
        flash[:success] = "blog edited."
        redirect_to(:action => "view", :id => @blog.id)
      end
    end
  end
  
  def friends_blogs
    user = User.find_by_id(params[:id])
    @blogs = user.mutual_friends.map(&:blogs).flatten.sort { |a, b| b.created_at <=> a.created_at }
    @page_title = "friends' blogs"
    render(:layout => false) if request.xhr?
  end
  
end