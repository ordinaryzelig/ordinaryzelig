class CreateMovieRatings < ActiveRecord::Migration
  def self.up
    create_table :movie_ratings do |t|
    end
  end

  def self.down
    drop_table :movie_ratings
  end
end
