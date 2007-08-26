class MessageBoardController < ApplicationController
  
  before_filter :validate_session, :except => ["index", "show"]
  
  #AJAX_ACTIONS = ["new", "post", "preview", "edit_new", "cancel"]
  ADMIN_ACTIONS = ["edit"]
  
  def index
    @messages_pages, @messages = paginate(:messages, :order => "posted_at desc")
    @page_title = "message board"
    render(:layout => false) if request.xhr?
  end
  
  def show
    @message = Message.find_by_id(params[:id])
  end
  
  def new
    if request.get?
      @message = Message.new
    else
      @message = Message.new(params[:message])
      @message.poster = logged_in_user
      if @message.save
        redirect_to(:action => "index")
      end
    end
  end
  
  def preview
    render(:partial => "shared/preview", :locals => {:entity => Message.new(params[:message])}) if request.xhr?
  end
  
end