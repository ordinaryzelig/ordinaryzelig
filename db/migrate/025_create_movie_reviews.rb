class CreateMovieReviews < ActiveRecord::Migration
  def self.up
    create_table :movie_reviews do |t|
    end
  end

  def self.down
    drop_table :movie_reviews
  end
end
