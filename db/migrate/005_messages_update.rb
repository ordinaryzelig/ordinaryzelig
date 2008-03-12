class MessagesUpdate < ActiveRecord::Migration
  
  use_two_sided_migration { Group.new DropFKey.new(:messages, :parent_id, {:reference_table => :messages}),
                                      RemoveColumn.new(:messages, :parent_id, :integer),
                                      RenameColumn.new(:messages, :posted_at, :created_at),
                                      DropFKey.new(:messages, :posted_by_user_id, {:reference_table => :users}),
                                      RenameColumn.new(:messages, :posted_by_user_id, :user_id),
                                      AddFKey.new(:messages, :user_id) }
  
end
