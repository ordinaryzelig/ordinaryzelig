class MessageBoardController < ApplicationController
  
  before_filter :validate_session, :except => ["index", "messages"]
  
  AJAX_ACTIONS = ["new", "post", "preview", "edit_new", "cancel"]
  ADMIN_ACTIONS = ["edit"]
  MESSAGES_PER_PAGE = 5
  
  def index
    @messages_pages, @messages = paginate(:messages, :order => "posted_at desc")
    @page_title = "message board"
    render(:layout => false) if request.xhr?
  end
  
  def show
    @message = Message.find_by_id(params[:id])
  end
  
  # params
  #   parent_id (optional)
  #   context
  def new
    if request.xhr?
      @context = params[:context]
      @message = Message.new
      # pre-fill with parent's subject.
      parent = Message.find_by_id(params[:parent_id])
      if parent
        @message.subject = parent.subject
        @message.parent_id = parent.id
      end
      render(:layout => false)
    end
  end
  
  def post
    if request.xhr?
      @message = Message.new(params[:message])
      @message.poster = logged_in_user
      @context = params[:context]
      @saved = @message.save
      if @saved
        @rendered = render_component_as_string(:action => "messages", :id => @message.id, :params => {:context => "child#{"_of_first_page" if "first_page" == @context}"})
      end
      render(:layout => false)
    end
  end
  
  def preview
    if request.xhr?
      @message = Message.new(params[:message])
      @message.validate
      render(:partial => "form", :locals => {:is_preview => true})
    end
  end
  
  def edit_new
    if request.xhr?
      @message = Message.new(params[:message])
      render(:partial => "form")
    end
  end
  
  # params
  #   id (message)
  def edit
    if request.get?
      @message = Message.find(params[:id])
    else
      @message = Message.find(params[:message][:id])
      if @message.update_attributes(params[:message])
        redirect_to(:action => "messages", :id => @message.id)
      end
    end
  end
  
  def cancel
    render(:nothing => true)
  end
  
end