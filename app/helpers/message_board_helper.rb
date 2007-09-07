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