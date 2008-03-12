class RemoveSeasonsIsCurrent < ActiveRecord::Migration
  
  use_two_sided_migration { Group.new RemoveIndex.new(:seasons, :is_current, :name => "seasons_is_current_key", :unique => true),
                                      RemoveColumn.new(:seasons, :is_current, :integer) }
  
end
