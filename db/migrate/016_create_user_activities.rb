class CreateUserActivities < ActiveRecord::Migration
  def self.up
    create_table :user_activities do |t|
    end
  end

  def self.down
    drop_table :user_activities
  end
end
