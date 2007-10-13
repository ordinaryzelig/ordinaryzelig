class NonUniqueReadItems < ActiveRecord::Migration
  def self.up
    remove_index :read_items, [:entity_type, :entity_id, :user_id]
  end

  def self.down
    add_index :read_items, [:entity_type, :entity_id, :user_id], :unique => true
  end
end
