class CreateMovieRatingTypes < ActiveRecord::Migration
  def self.up
    create_table :movie_rating_types do |t|
    end
  end

  def self.down
    drop_table :movie_rating_types
  end
end
