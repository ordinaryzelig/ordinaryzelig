module MessageBoardHelper
  
  def show_reply_form(message_id, js_options = {})
    snippets = []
    snippets << visual_effect(:blind_up, "reply_link_#{message_id}", js_options).gsub("\"", "\'")
    snippets << visual_effect(:blind_down, "reply_form_#{message_id}", js_options).gsub("\"", "\'")
    snippets << hide_spinner(message_id)
    snippets
  end
  
  def hide_reply_form(message_id, js_options = {})
    snippets = []
    snippets << visual_effect(:blind_down, "reply_link_#{message_id}", js_options).gsub("\"", "\'")
    snippets << visual_effect(:blind_up, "reply_form_#{message_id}", js_options).gsub("\"", "\'")
    snippets << show_spinner(message_id)
    snippets
  end
  
  def show_spinner(message_id)
    "Element.show('spinner_#{message_id}');"
  end
  
  def hide_spinner(message_id)
    "Element.hide('spinner_#{message_id}');"
  end
  
  def link_to_message(str, message_id)
    link_to(str, :controller => "message_board", :action => "messages", :id => message_id)
  end
  
  # return messageHeader div class depending on context and latest posting.
  def message_header_div_class(message, context)
    html_str = "messageHeader"
    if logged_in_user && logged_in_user.user_activity && logged_in_user.user_activity.previous_login_at
      if "child_of_first_page" == context
        # compare with message.latest_reply.
        message_to_compare = message.latest_message
      else
        # compare with message.
        message_to_compare = message
      end
      html_str << "Recent" if message_to_compare.latest_message.posted_at >= logged_in_user.user_activity.previous_login_at && !is_self?(message_to_compare.poster)
    end
    html_str
  end
  
  # based on the index of the message, should it show up on this page?
  def message_index_on_page?(index, page)
    if page
      min_index = (page - 1) * controller.class::MESSAGES_PER_PAGE
      max_index = min_index + controller.class::MESSAGES_PER_PAGE - 1
      index >= min_index && index <= max_index
    else
      # page not specified, so show all.
      true
    end
  end
  
end