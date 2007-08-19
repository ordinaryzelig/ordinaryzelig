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
    @page_title = @movie.title
    if request.post?
      if @review.update_attributes(params[:review])
        flash[:success] = "review saved."
        redirect_to(:action => "review", :id => @review.id)
      end
    end
  end
  
  def show
    @movie = Movie.find_by_id(params[:id], :include => :reviews)
    unless @movie
      flash[:failure] = "movie not found."
      redirect_to(:action => "index")
      return
    end
    @reviews = @movie.reviews.select { |review| review.review }
    @page_title = "#{@movie.title}"
  end
  
  def new
    @movie = Movie.new(params[:movie] ? params[:movie] : nil)
    redirect_to(:action => "edit_review", :movie_id => @movie.id) if request.post? && @movie.save
  end
  
  def edit
    @movie = Movie.find_by_id(params[:id]) || Movie.new
    if request.post?
      @movie.attributes = params[:movie]
      redirect_to(:action => "show", :id => @movie.id) and flash[:success] = "movie saved" if @movie.save
    end
  end
  
  def search
    if request.get?
      if params[:id] && params[:id].size > 0
        search_text = "%#{params[:id]}%"
        @movies = Movie.find(:all, :conditions => ["lower(title) like ?", search_text.downcase]) if search_text
      else
        flash.now[:failure] = "search for something."
      end
    else
      redirect_to(:action => "search", :id => params[:search_text])
    end
  end
  
end
