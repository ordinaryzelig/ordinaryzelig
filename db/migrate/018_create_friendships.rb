class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
    end
  end

  def self.down
    drop_table :friendships
  end
end
