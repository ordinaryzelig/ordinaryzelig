class MessagesUpdate < ActiveRecord::Migration
  def self.up
    remove_column :messages, :parent_id
    rename_column :messages, :posted_at, :created_at
    rename_column :messages, :posted_by_user_id, :user_id
    remove_fkey :messages, :posted_by_user_id
    fkey :messages, :user_id
  end

  def self.down
    add_column :messages, :parent_id, :integer
    rename_column :messages, :user_id, :posted_by_user_id
    rename_column :messages, :created_at, :posted_at
    remove_fkey :messages, :user_id
    fkey :messages, :posted_by_user_id, :users
  end
end
