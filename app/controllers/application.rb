# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  
  after_filter :mark_requested_page
  
  SESSION_HOURS = 24
  SESSION_FORCE_RELOGIN_DAYS = 3
  
  helper_method :logged_in_user, :current_season, :is_self?, :is_self_or_admin?
  
  def logged_in_user
    @logged_in_user ||= User.find_by_id(session[:user_id])
  end
  
  def current_season
    @current_season ||= Season::current
  end
  
  def validate_session
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
            redirect_to_last_marked_page_or_default
          end
        end
        return_val = true
      end
    end
    raise "something escaped validate_session()." if return_val.nil?
    return_val
  end
  
  def require_login(msg = "please log in.")
    mark_requested_page
    flash[:notice] = msg
    if is_ajax_action?
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
      session_expires_at < Time.now || need_force_relogin?
    else
      false
    end
  end
  
  def need_force_relogin?
    logged_in_user.user_activity.last_login_at + (SESSION_FORCE_RELOGIN_DAYS * 24 * 60 * 60) < Time.now
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
  def redirect_to_last_marked_page_or_default
    unless redirect_to_last_marked_page
      if logged_in_user.is_admin?
        redirect_to(:controller => "admin")
      else
        redirect_to(:controller => "user", :action => "profile", :id => logged_in_user)
      end
    end
  end
  
  def mark_requested_page
    session[:last_marked_page] = request.parameters unless is_ajax_action?
  end
  
  # assign user_id to session.
  def logged_in(user)
    session[:user_id] = user.id
    flash[:notice] = "logged in as #{logged_in_user.display_name}"
    set_last_authenticated_action_at
    redirect_to_last_marked_page_or_default
  end
  
  def is_self_or_admin?(user)
    is_self?(user) || logged_in_user.is_admin?
  end
  
  def is_self?(user)
    session[:user_id] == user.id
  end
  
  def is_ajax_action?
    if defined?(self.class::AJAX_ACTIONS)
      self.class::AJAX_ACTIONS.include?(action_name)
    end
  end
  
  def is_admin_action?(action = action_name)
    if defined?(self.class::ADMIN_ACTIONS)
      self.class::ADMIN_ACTIONS.include?(action)
    end
  end
  
  def recents
    @recents = EntityType.find(:all).map do |entity_type_obj|
      entity_type_obj.entity_class.recents(logged_in_user)
    end.flatten.sort { |a, b| b.recency_time_obj <=> a.recency_time_obj }
    @recents = @recents.map { |ent| ent.class == Comment ? ent.entity : ent }
    @recents = @recents.uniq
  end
  
end