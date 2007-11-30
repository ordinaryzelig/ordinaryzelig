class BlogController < ApplicationController
  
  before_filter :require_authentication, :except => [:show]
  
  def list
    @user = User.find_by_id(params[:id], :include => {:blogs => :user}, :order => "created_at desc")
    @blogs = @user.blogs
    @blogs = @blogs.readable_by logged_in_user unless is_self_or_logged_in_as_admin?(@user)
    render_layout_only 'user not found' and return unless @user
    @page_title = "#{@user.display_name}'s blogs"
  end
  
  def show
    @blog = Blog.find_by_id(params[:id], :include => :user)
    render_layout_only 'blog not found' and return unless @blog
    render_layout_only 'this is private.' and return unless logged_in_user && logged_in_user.can_read?(@blog)
    @page_title = "blog - #{@blog.title}"
  end
  
  def new
    redirect_to :action => 'edit'
  end
  
  def edit
    @blog = Blog.find_by_id(params[:id]) || Blog.new
    @page_title = "#{controller_name} - #{@blog.new_record? ? 'new' : 'edit'}"
    if request.post?
      @blog.attributes = params[:blog]
      @blog.user ||= logged_in_user
      if @blog.save
        @blog.privacy_level.update_attributes(:privacy_level_type_id => params[:privacy_level_type_id])
        flash[:success] = "blog saved."
        redirect_to(:action => "show", :id => @blog.id)
      end
    end
  end
  
  preview_action_for
  
  def friends_blogs
    @blogs = logged_in_user.friends.blogs(logged_in_user)
    @page_title = "friends' blogs"
    render(:layout => false) if request.xhr?
  end
  
end
