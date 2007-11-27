class Privacy < ActiveRecord::Migration
  def self.up
    create_table :privacy_level_types do |t|
      t.column :name, :string, {:null => false}
    end
    
    create_table :privacy_levels do |t|
      t.column :entity_type, :string, {:null => false}
      t.column :entity_id, :integer, {:null => false}
      t.column :privacy_level_type_id, :integer, {:null => false}
    end
    fkey :privacy_levels, :entity_type, :entity_types, :name
    fkey :privacy_levels, :privacy_level_type_id
  end

  def self.down
    drop_table :privacy_levels
    drop_table :privacy_level_types
  end
end
