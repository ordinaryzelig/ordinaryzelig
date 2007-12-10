class RemoveSeasonsIsCurrent < ActiveRecord::Migration
  def self.up
    remove_column :seasons, :is_current
  end

  def self.down
    add_column :seasons, :is_current, :integer
  end
end
