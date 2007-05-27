class CreateCommentGroups < ActiveRecord::Migration
  def self.up
    create_table :comment_groups do |t|
    end
  end

  def self.down
    drop_table :comment_groups
  end
end
