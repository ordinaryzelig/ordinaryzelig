class MessageBoardController < ApplicationController
  
  before_filter :validate_session, :only => ["new", "preview"]
  
  ADMIN_ACTIONS = ["edit"]
  
  def index
    @page_title = "message board"
    message_board_pagination
  end
  
  def message_board_pagination
    @messages_pages, @messages = paginate(:messages, :order => "posted_at desc")
    render(:partial => "message_board_pagination") if request.xhr?
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
    if request.xhr?
      @message = Message.new(params[:message])
    end
    render(:layout => false)
  end
  
end