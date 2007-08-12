class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
    end
  end

  def self.down
    drop_table :movies
  end
end
