class CommentsController < ApplicationController
  
  before_filter :require_authentication
  
  # params:
  #   parent_id or
  #   entity_type and entity_id
  def new
    if request.xhr?
      @comment = Comment.new(params[:comment] || {:parent_id => params[:parent_id],
                                                  :entity_type => params[:entity_type],
                                                  :entity_id => params[:entity_id]})
      render(:layout => false)
    end
  end
  
  def post
    do_post
  end
  
  def preview
    do_post
  end
  
  def cancel
    render(:nothing => true)
  end
  
  private
  
  def do_post
    if request.xhr?
      @comment = Comment.new(params[:comment])
      @comment.user_id ||= logged_in_user.id
      if action_name == "post"
        if @comment.parent_id
          @id_to_update = "comment_children_#{@comment.parent_id}"
        else
          @id_to_update = "comments"
        end
        @comment.save!
        @rendered_partial = render_to_string(:partial => "comment", :locals => {:comment => @comment})
        render(:action => "post", :layout => false)
      else
        render(:partial => "shared/preview", :locals => {:entity => @comment})
      end
    end
  end
  
end