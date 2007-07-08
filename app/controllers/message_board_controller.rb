class MessageBoardController < ApplicationController
  
  before_filter :validate_session, :except => ["index", "show"]
  
  ADMIN_ACTIONS = ["edit"]
  
  def index
    @page_title = "message board"
    paginate_entity(Message)
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
  
  # ajaxy.
  
  # def post
  #   if request.xhr?
  #     @message = Message.new(params[:message])
  #     @message.poster = logged_in_user
  #     @context = params[:context]
  #     @saved = @message.save
  #     if @saved
  #       @rendered = render_component_as_string(:action => "messages", :id => @message.id, :params => {:context => "child#{"_of_first_page" if "first_page" == @context}"})
  #     end
  #     render(:layout => false)
  #   end
  # end
  # 
  # def edit_new
  #   if request.xhr?
  #     @message = Message.new(params[:message])
  #     render(:partial => "form")
  #   end
  # end
  # 
  # # params
  # #   id (message)
  # def edit
  #   if request.get?
  #     @message = Message.find(params[:id])
  #   else
  #     @message = Message.find(params[:message][:id])
  #     if @message.update_attributes(params[:message])
  #       redirect_to(:action => "messages", :id => @message.id)
  #     end
  #   end
  # end
  # 
  # def cancel
  #   render(:nothing => true)
  # end
  
end