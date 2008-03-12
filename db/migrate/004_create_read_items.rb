class CreateReadItems < ActiveRecord::Migration
  
  CreateReadItems = CreateTable.new :read_items do |t|
    t.column :entity_type, :string, :null => false
    t.column :entity_id, :integer, :null => false
    t.column :user_id, :integer, :null => false
    t.column :read_at, :datetime, :null => false
  end
  use_two_sided_migration { Group.new CreateReadItems,
                                      AddIndex.new(:read_items, [:entity_type, :entity_id, :user_id], :unique => true),
                                      AddFKey.new(:read_items, :entity_type, {:reference_table => :entity_types, :reference_column => :name}),
                                      AddFKey.new(:read_items, :user_id) }
end
