# Methods added to this helper will be available to all templates in the application.

require 'time_units'

module ApplicationHelper
  
  def season_select_tag(season_id = nil)
    select_tag(:season_id, options_for_select(Season::container, season_id))
  end
  
  # return link to user's profile.  displays str.
  def link_to_profile(user, str = user.display_name)
    link_to(h(str), {:controller => "user", :action => "profile", :id => user.id})
  end
  
  def link_to_edit_profile(str, user)
    link_to(h(str), {:controller => "user", :action => "edit_profile", :id => user.id})
  end
  
  def link_to_bracket(str, pool_user, options = {})
    options.store(:action, "brackets")
    options.store(:id, pool_user.user_id)
    options.store(:season_id, pool_user.season_id)
    link_to(str, options)
  end
  
  def link_to_email(str, user)
    link_to(str, url_for("mailto:#{user.email}"))
  end
  
  def error_messages(model_obj)
    if !model_obj.errors.empty?
      div_id = "error_messages_#{model_obj.__id__}"
      rhtml_str = "<div class=errorMessages id=\"#{div_id}\">#{model_obj.errors.full_messages.join("<br>")}</div>"
      rhtml_str
    end
  end
  
  def default_time_format(time)
    time.strftime("%A %B %d, %I:%M %p %Z") if time
  end
  
  def link_to_my_bracket
    link_to("(mine)", {:controller => "pool", :action => "brackets", :id => logged_in_user.id, :season_id => current_season.id}, :id => "myBracket")
  end
  
  # return 1 or 0 for true or false.
  # if obj is nil, return nil.
  def boolean_to_i(obj)
    if obj.nil?
      nil
    else
      if obj
        1
      else
        0
      end
    end
  end
  
  def time_til(time)
    pract = Time.now.time_til(time).to_practical
    str = pract.practical(true)
    if pract.is_negative?
      str << " ago"
    elsif "0 seconds" == str
      str = "now"
    else
      str = "in #{str}"
    end
    str
  end
  
  def default_time(time)
    "#{default_time_format(time)} (#{time_til(time)})" if time
  end
  
  def hide_banner
    content_for("banner") { "" }
  end
  
  def link_to_page(str, page, object_class)
    is_current_page = page && page.paginator.current == page
    content = if page && !is_current_page
      pagination_area_div = "#{object_class}PaginationArea"
      pagination_objects_div = "#{object_class}PaginationObjects"
      link_to_remote(str, {:url => {:page => page.number},
                           :update => pagination_area_div,
                           :before => stack("Element.show('#{object_class}PaginationSpinner');",
                                            visual_effect(:blind_up, pagination_objects_div, {:queue => 'end'})),
                           :complete => visual_effect(:blind_down, pagination_objects_div, {:queue => 'end'})}
      )
    else
      str
    end
    content_tag(:span, content, :id => paginated_page_num_id(object_class, str), :style => is_current_page ? "font-size: 120%; color: red;" : nil)
  end
  
  def paginated_page_num_id(object_class, str)
    "#{Inflector::pluralize(object_class.to_s)}_page_#{str}"
  end
  
  def recent_background_color(object, default_color = "lightgray")
    color = (logged_in_user && object.is_recent?(logged_in_user)) ? "lightgreen" : default_color
    "background-color: #{color};" if color
  end
  
  def comment_info(entity)
    latest_comment = entity.latest_comment
    if latest_comment
      "last comment: #{link_to_profile(latest_comment.user)} - #{default_time(latest_comment.created_at)}"
    else
      "no comments"
    end
  end
  
  # ===========================================================
  # comment ajax methods.
  
  def show_comment_spinner(comment_id)
    visual_effect(:slide_down, "comment_spinner_#{comment_id}")
  end
  
  def hide_comment_spinner(comment_id)
    visual_effect(:slide_up, "comment_spinner_#{comment_id}")
  end
  
  def show_comment_action_bar(action, comment_id)
    visual_effect(:blind_down, "comment_action_bar_#{action}_#{comment_id}", :queue => {:position => 'end', :scope => 'action_bar'})
  end
  
  def hide_comment_action_bar(action, comment_id)
    visual_effect(:blind_up, "comment_action_bar_#{action}_#{comment_id}", :queue => {:position => 'end', :scope => 'action_bar'})
  end
  
  def show_comment_form(comment_id)
    div_id = "comment_form_#{comment_id}"
    stack("Element.hide('#{div_id}');", visual_effect(:slide_down, div_id, {:queue => {:position => 'end', :scope => 'comment_form'}}))
  end
  
  def hide_comment_form(comment_id)
    visual_effect(:slide_up, "comment_form_#{comment_id}", {:queue => {:position => 'end', :scope => 'comment_form'}})
  end
  
  def remove_comment_form_content(comment_id)
    "Element.remove('comment_form_content_#{comment_id}');"
  end
  
  def stack(*effects)
    effects.join(" ")
  end
  
  def focus(id)
    "$('#{id}').focus();"
  end
  
end