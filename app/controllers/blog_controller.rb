class BlogController < ApplicationController
  
  before_filter :require_authentication, :except => [:show]
  
  def list
    @user = User.find_by_id(params[:id], :include => {:blogs => :user}, :order => "#{Blog.table_name}.created_at desc")
    unless @user
      render_layout_only 'user not found'
      return 
    end
    user_title @user
    @blogs = @user.blogs
    # narrow to blogs readable by logged_in_user if this is not self or admin.
    @blogs = @blogs.readable_by logged_in_user unless is_self_or_logged_in_as_admin?(@user)
  end
  
  def show
    @blog = Blog.find_by_id(params[:id].to_i, :include => :user)
    unless @blog
      render_layout_only 'blog not found'
      return
    end
    unless 'anybody' == @blog.privacy_level.to_s || logged_in_user && logged_in_user.can_read?(@blog)
      render_layout_only 'this is private.'
      return
    end
    title "blog - #{@blog.title}"
  end
  
  def new
    redirect_to :action => 'edit'
  end
  
  def edit
    @blog = Blog.find_by_id(params[:id], :include => [:user, :privacy_level]) || Blog.new
    if params[:id] && @blog.new_record?
      render_layout_only 'blog not found.'
      return
    end
    if !@blog.new_record? && !is_self_or_logged_in_as_admin?(@blog.user)
      render_layout_only 'you can\'t edit that blog.'
      return
    end
    @page_title = "#{controller_name} - #{@blog.new_record? ? 'new' : 'edit'}"
    if request.post?
      @blog.attributes = params[:blog]
      @blog.user ||= logged_in_user
      if @blog.save
        flash[:success] = "blog saved."
        redirect_to(:action => "show", :id => @blog.id)
      end
    end
  end
  
  preview_action_for
  
  def by_friends
    @blogs = Blog.readable_by logged_in_user
    @page_title = "friends' blogs"
  end
  
end
