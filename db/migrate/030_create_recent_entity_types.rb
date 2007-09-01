class CreateRecentEntityTypes < ActiveRecord::Migration
  def self.up
    create_table :recent_entity_types do |t|
    end
  end

  def self.down
    drop_table :recent_entity_types
  end
end
