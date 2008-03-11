class RemoveSeasonsIsCurrent < ActiveRecord::Migration
  
  use_two_sided_migration { RemoveColumn.new(:seasons, :is_current) }
  
end
