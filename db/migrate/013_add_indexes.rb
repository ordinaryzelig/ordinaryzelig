class AddIndexes < ActiveRecord::Migration
  
  ADD_INDEXES = {:users => [:last_name, :first_name, :display_name],
                 :friendships => :created_at,
                 :teams => :name,
                 :pics => :pool_user_id,
                 :messages => :created_at,
                 :blogs => :created_at,
                 :comments => :created_at,
                 :movie_ratings => :created_at,
                 :read_items => :read_at}
  use_two_sided_migration { Group.new(*ADD_INDEXES.map { |table_name, columns| AddIndex.new(table_name, columns) }) }
  
end
