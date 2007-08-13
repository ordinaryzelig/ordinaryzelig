class MovieController < ApplicationController
  
  before_filter :validate_session, :only => [:review]
  
  def index
    redirect_to(:action => "reviews")
  end
  
  def reviews
    @movies = Movie.by_latest_reviews
  end
  
  def review
    @movie = Movie.find_by_id(params[:id])
    unless @movie
      flash[:failure] = "movie not found."
      redirect_to(:action => "reviews")
    end
    @page_title = "#{@movie.title} review"
    
    if request.get?
      @review = MovieReview.new(:movie_id => params[:id])
      # check if user already reviewed.
    else
      @review = MovieReview.new(params[:review])
      @review.user ||= logged_in_user
      if @review.save
        flash[:success] = "review saved."
        redirect_to(:action => "reviews")
      end
    end
  end
  
end
