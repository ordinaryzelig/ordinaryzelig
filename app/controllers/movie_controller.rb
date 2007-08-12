class MovieController < ApplicationController
  
  def index
    redirect_to(:action => "reviews")
  end
  
  def reviews
    @movies = Movie.by_latest_reviews
  end
  
  def review
    if request.get?
      @movie_review = MovieReview.new(:movie_id => params[:id])
      # check if user already reviewed.
    else
      @movie_review = MovieReview.new(params[:movie_review])
      if @movie_review.save
        flash[:success] = "reviewed saved."
        redirect_to(:action => "reviews")
      end
    end
  end
  
end
