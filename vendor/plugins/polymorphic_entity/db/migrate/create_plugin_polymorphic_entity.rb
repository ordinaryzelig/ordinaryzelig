class CreatePluginPolymorphicEntity < ActiveRecord::Migration
  
  def self.up
    create_table :entity_types do |t|
      t.column :name, :string, {:null => false}
    end
    add_index :entity_types, :name, {:unique => true}
  end
  
  def self.down
    drop_table :entity_types
  end
  
end
