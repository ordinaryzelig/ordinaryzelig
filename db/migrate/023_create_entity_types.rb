class CreateEntityTypes < ActiveRecord::Migration
  def self.up
    create_table :entity_types do |t|
    end
  end

  def self.down
    drop_table :entity_types
  end
end
