class CreateMovieRatingOptions < ActiveRecord::Migration
  def self.up
    create_table :movie_rating_options do |t|
    end
  end

  def self.down
    drop_table :movie_rating_options
  end
end
