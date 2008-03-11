class MessagesUpdate < ActiveRecord::Migration
  
  use_two_sided_migration { Group.new(RemoveColumn.new(:messages, :parent_id),
                                      RenameColumn.new(:messages, :posted_at, :created_at),
                                      RenameColumn.new(:messages, :posted_by_user_id, :user_id),
                                      RemoveFKey.new(:messages, :posted_by_user_id),
                                      AddFKey(:messages, :user_id)) }
  
end
