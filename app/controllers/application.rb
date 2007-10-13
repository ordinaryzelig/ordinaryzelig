class ApplicationController < ActionController::Base
  
  after_filter :mark_requested_page
  
  SESSION_HOURS = 30
  
  helper_method :logged_in_user, :current_season, :is_self?, :is_self_or_logged_in_as_admin?, :logged_in_as_admin?, :read_entities
  
  def mark_entity_as_read
    Object.const_get(params[:entity_type]).find_by_id(params[:id]).mark_as_read(logged_in_user) if request.xhr?
  end
  
  protected
  
  def logged_in_user
    @logged_in_user ||= User.find_by_id(session[:user_id])
  end
  
  def current_season
    @current_season ||= Season::current
  end
  
  def require_authentication
    unless session[:user_id]
    # not logged in.
      require_login
      return_val = false
    else
    # already logged in.
      if session_expired?
        require_login
        return_val = false
      else
        set_last_authenticated_action_at
        # validate more if admin action.
        if is_admin_action?
          unless logged_in_user.is_admin?
            flash[:failure] = "you must be an administrator to do that."
            redirect_to_last_marked_page_or_default({:action => "index"})
          end
        end
        return_val = true
      end
    end
    raise "something escaped require_authentication() return_val." if return_val.nil?
    return_val
  end
  
  def require_login(msg = "please log in.")
    mark_requested_page
    flash[:notice] = msg
    if request.xhr?
      render :update do |page|
        page.redirect_to(:controller => 'login')
      end
    else
      redirect_to :controller => "login"
    end
  end
  
  # check session expiration.
  # return whether session is valid (has not expired).
  def session_expired?
    if session[:last_authenticated_action_at]
      session_expires_at = session[:last_authenticated_action_at] + (60 * 60 * SESSION_HOURS)
      session_expires_at < Time.now
    else
      false
    end
  end
  
  def set_last_authenticated_action_at
    session[:last_authenticated_action_at] = Time.now
  end
  
  # attempt to redirect to last_marked_page.
  # return if redirected somewhere.
  # false if didn't redirect anywhere.
  def redirect_to_last_marked_page
    if session[:last_marked_page]
      redirect_to session[:last_marked_page]
      session[:last_marked_page] = nil
      true
    else
      false
    end
  end
  
  # try to go to last marked page.
  # otherwise, go to default.
  def redirect_to_last_marked_page_or_default(default = {:controller => "user", :action => "profile", :id => logged_in_user})
    logged_in_user.is_admin? ? redirect_to(:controller => "admin") : redirect_to(default) unless redirect_to_last_marked_page
  end
  
  def mark_requested_page
    session[:last_marked_page] = request.parameters unless request.xhr?
  end
  
  # assign user_id to session.
  def logged_in(user)
    session[:user_id] = user.id
    flash[:notice] = "logged in as #{logged_in_user.display_name}"
    set_last_authenticated_action_at
    redirect_to_last_marked_page_or_default
  end
  
  def is_self_or_logged_in_as_admin?(user)
    is_self?(user) || logged_in_as_admin?
  end
  
  def logged_in_as_admin?
    logged_in_user && logged_in_user.is_admin?
  end
  
  def is_self?(user)
    user && user.id == session[:user_id]
  end
  
  def is_admin?(user)
    user && user.is_admin?
  end
  
  def is_admin_action?(action = action_name)
    if defined?(self.class::ADMIN_ACTIONS)
      self.class::ADMIN_ACTIONS.include?(action)
    end
  end
  
  def rescue_action(ex)
    case ex
    when ::ActionController::UnknownAction
      flash[:failure] = "the page you requested does not exist."
      redirect_to_last_marked_page_or_default
    else
      if ENV['RAILS_ENV'] == 'production'
        render(:file => "#{RAILS_ROOT}/public/500.html", :status => "500 Error")
        begin
          email = Notifier.deliver_exception(ex, logged_in_user)
        rescue Exception => e
          logger.error "error sending mail #{Time.now.localtime}\n#{e}\n#{e.backtrace.join("\n")}"
        end
      else
        super
      end
    end
  end
  
  def render_layout_only(msg, flash_type = :failure)
    flash.now[flash_type] = msg if msg
    render :nothing => true, :layout => true
  end
  
end
