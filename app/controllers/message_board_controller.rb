class MessageBoardController < ApplicationController
  
  before_filter :require_authentication, :except => ["index", "show"]
  
  ADMIN_ACTIONS = ["edit"]
  
  def index
    @messages = Message.paginate(:page => params[:page] || 1, :order => "created_at desc", :per_page => 10)
    title "message board"
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
      @message.user = logged_in_user
      if @message.save
        redirect_to(:action => "index")
      end
    end
  end
  
  preview_action_for :messages
  
end
