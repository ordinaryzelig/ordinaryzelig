class NonUniqueReadItems < ActiveRecord::Migration
  
  use_two_sided_migration { RemoveIndex.new(:read_items, [:entity_type, :entity_id, :user_id], :unique => true) }
  
end
