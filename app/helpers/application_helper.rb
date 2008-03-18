# Methods added to this helper will be available to all templates in the application.

require 'time_units'

module ApplicationHelper
  
  def season_select_tag(season_id = nil)
    select_tag(:season_id, options_for_select(Season.container, season_id))
  end
  
  def link_to_profile(user, str = user.display_name, highlight_text = nil)
    str = h(str)
    str = highlight(str, highlight_text) if highlight_text
    link_to(str, {:controller => "user", :action => "profile", :id => user.id})
  end
  
  def link_to_edit_profile(str, user)
    link_to(h(str), {:controller => "user", :action => "edit_profile", :id => user.id})
  end
  
  def link_to_bracket(str, pool_user, options = {})
    link_to str, options.merge({:action => 'bracket', :id => pool_user.user_id, :season_id => pool_user.season_id, :bracket_num => pool_user.bracket_num})
  end
  
  def link_to_email(str, user)
    mail_to(user.email, str, :encode => "javascript")
  end
  
  def link_to_login(to_do_str)
    content_tag(:span, "#{link_to("login", :controller => "login")} #{to_do_str}", :style => "font-size: 10pt;")
  end
  
  def error_messages(model_obj)
    if !model_obj.errors.empty?
      div_id = "error_messages_#{model_obj.__id__}"
      rhtml_str = "<div class=errorMessages id=\"#{div_id}\">#{model_obj.errors.full_messages.join("<br/>")}</div>"
      rhtml_str
    end
  end
  
  def default_time_format(time)
    TimeZone["Central Time (US & Canada)"].adjust(time).strftime("%A %B %d, %I:%M %p %Z") if time
  end
  
  def time_til(time)
    Time.now.time_til(time).practical
  end
  
  def clickable_time(time, default_time_format_first = false, style = 'font-size: 75%; color: gray;')
    if default_time_format_first
      content = default_time_format(time)
      title = time_til(time)
    else
      content = time_til(time)
      title = default_time_format(time)
    end
    content_tag :span, content, :title => title, :onclick => 'switch_time_format(this);', :style => style
  end
  
  def link_to_my_bracket
    link_to('your bracket', {:controller => "pool",
                             :action => 'bracket',
                             :id => logged_in_user.id,
                             :season_id => latest_season.id})
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
  
  def submit_to_remote_preview(str = "preview", url = {:action => "preview"})
    submit_to_remote(:preview, str, {:update => "preview", :url => url, :complete => visual_effect(:slide_down, 'preview')})
  end
  
  def preview_div
    content_tag(:div, nil, {:id => "preview", :style => "display: none;"})
  end
  
  def paginated_page_num_id(object_class, str)
    "#{Inflector::pluralize(object_class.to_s)}_page_#{str}"
  end
  
  def recent_background_color(object, default_color = "lightgray")
    color = (logged_in_user && object.class.has_recency? && object.is_recent?(logged_in_user)) ? "lightgreen" : default_color
    "background-color: #{color};" if color
  end
  
  def mark_as_read_link(entity, hide_entity = false)
    link = link_to_remote('mark as read', {:url => {:action => 'mark_entity_as_read',
                                                    :entity_type => entity.class,
                                                    :id => entity.id,
                                                    :hide_entity => hide_entity || nil}})
    content_tag :span, link, :style => 'font-size: 75%;', :id => "markAsReadLink_#{entity.div_id}"
  end
  
  def mark_as_read_div(entity, hide_entity = false)
    content_tag :div, mark_as_read_link(entity, hide_entity), :style => 'float: right;'
  end
  
  def simp_san(text)
    simple_format(sanitize(text))
  end
  
  def privacy_level_select(privacy_level)
    select_tag :privacy_level_type_id, options_for_select(PrivacyLevelType.container, privacy_level ? privacy_level.privacy_level_type_id : 2)
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
  
  def show_preview(comment_id)
    visual_effect(:slide_down, "comment_preview_#{comment_id}")
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
  
  def css_centered
    'margin-left: auto; margin-right: auto;'
  end
  
  def spinner(id = nil)
    image_tag("spinner.gif", :id => id, :style => "display: none;")
  end
  
end
