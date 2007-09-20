class CreateReadItems < ActiveRecord::Migration
  def self.up
    create_table :read_items do |t|
      t.column :entity_type, :string, :null => false
      t.column :entity_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
      t.column :read_at, :datetime, :null => false
    end
    add_index :read_items, [:entity_type, :entity_id, :user_id], :unique => true
    fkey :read_items, :entity_type, :entity_types, :name
    fkey :read_items, :user_id
  end

  def self.down
    drop_table :read_items
  end
end
