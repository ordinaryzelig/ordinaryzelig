class CalendarController < ApplicationController
  
  before_filter :require_authentication
  
  def view
    @events = Event.find(:all, :conditions => ["starts_at > ?", Date.today], :order => "starts_at")
  end
  
  def new_event
    if request.get?
      @event = Event.new(:ends_at => 1.hours.from_now)
      @event.created_by_user_id = logged_in_user.id
      @event.starts_at = 1.days.from_now
      @event.ends_at = 1.hours.from_now + 1.days
    else
      @event = Event.new(params[:event])
      if @event.save
        flash[:success] = "new event created"
        redirect_to(:action => "edit_event", :id => @event.id)
      end
    end
  end
  
  def edit_event
    @event = Event.find_by_id(params[:id])
    if @event
      if request.post?
        if @event.update_attributes(params[:event])
          flash[:success] = "event saved."
          redirect_to(:action => "view")
        end
      end
    else
      flash[:failure] = "could not find event."
      redirect_to(:action => "view")
    end
  end
  
end
