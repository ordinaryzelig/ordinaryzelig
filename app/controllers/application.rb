class ApplicationController < ActionController::Base
  
  after_filter :mark_requested_page
  
  SESSION_HOURS = 30 unless defined? SESSION_HOURS
  PAGE_DOES_NOT_EXIST = "the page you requested does not exist." unless defined? PAGE_DOES_NOT_EXIST
  
  helper_method :logged_in_user,
                :latest_season,
                :is_self?,
                :is_self_or_logged_in_as_admin?,
                :logged_in_as_admin?,
                :read_entities,
                :page_title
  
  def mark_entity_as_read_by
    if request.xhr?
      @entity = Object.const_get(params[:entity_type]).find_by_id(params[:id])
      @entity.mark_as_read_by(logged_in_user)
      render :update do |page|
        if params[:hide_entity]
          page[dom_id(@entity)].visual_effect(:switch_off)
          page.replace_html :recentItemsCount, pluralize(logged_in_user.recents.size, 'recent item')
        else
          # change color.
          page["entity_header_#{@entity.id}"].bgColor = 'lightgray'
          page.replace_html "#{dom_id(@entity, 'markAsReadLink')}", '<i>read</i>'
        end
      end
    end
  end
  
  protected
  
  def logged_in_user
    @logged_in_user ||= User.find_by_id(session[:user_id])
  end
  
  def latest_season
    @latest_season ||= Season.latest
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
            flash[:failure] = PAGE_DOES_NOT_EXIST
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
    redirect_to(default) unless redirect_to_last_marked_page
  end
  
  def mark_requested_page
    session[:last_marked_page] = request.parameters unless request.xhr?
  end
  
  # assign user_id to session.
  def logged_in(user)
    session[:user_id] = user.id
    flash[:notice] = "logged in as #{logged_in_user.display_name}"
    set_last_authenticated_action_at
    redirect_to_last_marked_page_or_default(user.is_admin? ? {:controller => 'admin'} : {:controller => 'user', :action => 'profile', :id => user.id})
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
  
  def is_admin_action?(action = action_name)
    if defined?(self.class::ADMIN_ACTIONS)
      self.class::ADMIN_ACTIONS.include?(action)
    end
  end
  
  def rescue_action(ex)
    case ex
    when ::ActionController::UnknownAction
      flash[:failure] = PAGE_DOES_NOT_EXIST
      redirect_to_last_marked_page_or_default
    when FriendlyError
      # just render the layout and flash[:failure] msg.
      if ENV['RAILS_ENV'] == 'production'
        render_layout_only ex.msg
      else
        super
      end
    else
      if ENV['RAILS_ENV'] == 'production'
        render(:file => "#{RAILS_ROOT}/public/500.html", :status => "500 Error")
        begin
          email = Notifier.deliver_exception(ex, logged_in_user, request)
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
  
  def self.preview_action_for(table_name = controller_name, options = {})
    options[:use_simp_san] = true if options[:use_simp_san].nil?
    singular = ActiveSupport::Inflector.singularize(table_name.to_s)
    model_class = Object.const_get singular.classify
    define_method :preview do
      render(:partial => "shared/preview", :locals => {:entity => model_class.new(params[singular.downcase]), :use_simp_san => options[:use_simp_san]}) if request.xhr?
    end
  end
  
  def default_page_title
    "#{controller_name_for_page_title.gsub('_',' ')} - #{action_name.gsub('_', ' ')}"
  end
  
  def page_title
    @page_title ||= default_page_title
  end
  
  def controller_name_for_page_title
    controller_name
  end
  
  def title(t)
    @page_title = t
  end
  
  def user_title(user)
    title "#{default_page_title} - #{user.display_name}"
  end
  
  # rescue exceptions and raise FriendlyError instead.
  # rescue_action will handle FriendlyError.
  def rescue_friendly(default_msg = 'there was an error', force_default_msg = false)
    yield
  rescue Exception => ex
    friendly_msg = force_default_msg ? default_msg : case ex
    when FriendlyError
      ex.msg
    else
      default_msg
    end
    raise FriendlyError.new(friendly_msg, ex)
  end
  
end

class FriendlyError < StandardError
  attr_reader :msg, :original_exception
  def initialize(msg, original_exception = nil)
    @msg = msg
    @original_exception = original_exception.is_a?(FriendlyError) ? original_exception.original_exception : original_exception
  end
  def to_s
    str = "#{self.class}: #{msg}"
    str += " (#{original_exception.message})" if original_exception && !original_exception.message.blank?
    str
  end
  def backtrace
    original_exception ? original_exception.backtrace : super
  end
end
