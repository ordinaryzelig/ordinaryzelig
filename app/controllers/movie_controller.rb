class MovieController < ApplicationController
  
  before_filter :validate_session, :only => [:edit_review, :edit]
  ADMIN_ACTIONS = ["edit"]
  
  def index
    flash.keep
    redirect_to(:action => "reviews")
  end
  
  def reviews
    @movies = Movie.by_latest_reviews
  end
  
  def review
    @review = MovieReview.find_by_id(params[:id])
    unless @review
      flash[:failure] = "review not found."
      redirect_to(:action => "reviews")
      return
    end
    @page_title = @review.movie.title
  end
  
  def edit_review
    @review = MovieReview.find_by_id(params[:id]) || MovieReview.new(:movie_id => params[:movie_id], :user_id => logged_in_user.id)
    @movie = @review.movie || Movie.find_by_id(params[:movie_id])
    unless @movie
      flash[:failure] = "movie not found."
      redirect_to(:action => "reviews")
      return
    end
    
    if request.post?
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
  
  def edit
    @movie = Movie.find_by_id(params[:id]) || Movie.new
    if request.post?
      @movie.attributes = params[:movie]
      redirect_to(:action => "reviews") if @movie.save
    end
  end
  
end
