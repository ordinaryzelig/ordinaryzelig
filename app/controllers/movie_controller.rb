class MovieController < ApplicationController
  
  before_filter :validate_session, :only => [:review]
  
  def index
    redirect_to(:action => "reviews")
  end
  
  def reviews
    @movies = Movie.by_latest_reviews
  end
  
  def review
    @review = MovieReview.find_by_id(params[:id]) || MovieReview.new(:movie_id => params[:movie_id], :user_id => logged_in_user.id)
    
    @movie = @review.movie || Movie.find_by_id(params[:movie_id])
    unless @movie
      flash[:failure] = "movie not found."
      redirect_to(:action => "reviews")
      return
    end
    @page_title = @movie.title
    
    if request.get?
      if @review.new_record?
        # check if user already reviewed.
        @mode = "edit"
        @page_title = @page_title + " review"
      else
        @mode = "show"
      end
    else
      if @review.update_attributes(params[:review])
        flash[:success] = "review saved."
        redirect_to(:action => "reviews")
      end
    end
  end
  
  def show
    @movie = Movie.find_by_id(params[:id], :include => :reviews)
    @page_title = "#{@movie.title}"
  end
  
end
