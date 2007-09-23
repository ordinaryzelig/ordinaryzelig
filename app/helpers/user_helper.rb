module UserHelper
  
  def link_to_add_remove_friend(action, user_id)
    if "add_friend" == action
      msg = "add friend"
    else
      msg = "remove friend"
    end
    link_to_remote(msg, :url => {:action => action, :id => user_id},
                        :update => "addRemoveFriend",
                        :before => "Element.show('addRemoveFriendSpinner');")
  end
  
  def link_to_considering_friends(str, user, hide_mutual_friends = false)
    link_to(str, :action => "friends_to", :hide_mutual_friends => hide_mutual_friends)
  end
  
end
