class CreateUserActivityTypes < ActiveRecord::Migration
  def self.up
    create_table :user_activity_types do |t|
    end
  end

  def self.down
    drop_table :user_activity_types
  end
end
