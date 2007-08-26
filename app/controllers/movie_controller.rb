class MovieController < ApplicationController
  
  before_filter :validate_session, :only => [:new_review, :edit, :new]
  ADMIN_ACTIONS = ["edit"]
  helper_method :existing_review?
  
  def index
    flash.keep
    redirect_to(:action => "reviews")
  end
  
  def reviews
    @movies = Movie.by_latest_reviews
  end
  
  def review
    @review = MovieRating.find_by_id(params[:id])
    unless @review
      flash[:failure] = "review not found."
      redirect_to(:action => "reviews")
      return
    end
    @page_title = @review.movie.title
  end
  
  def new_review
    @movie = Movie.find_by_id(params[:movie_id] || params[:movie_rating][:movie_id], :include => :reviews)
    # check for existing movie.
    unless @movie
      flash[:failure] = "movie not found."
      redirect_to(:action => "reviews")
      return
    end
    # check for existing user review.
    if existing_review?(@movie)
      flash[:failure] = "you've already written a review for this movie."
      redirect_to(:action => "show", :id => params[:movie_id])
      return
    end
    
    rating_type = MovieRatingType.find(1)
    if request.get?
      @movie_rating = MovieRating.new(:movie_id => params[:movie_id], :user_id => logged_in_user.id, :rating_type => rating_type)
      @page_title = @movie.title
    else
      @movie_rating = MovieRating.new(params[:movie_rating])
      @movie_rating.rating_type = rating_type
      if @movie_rating.save
        flash[:success] = "review saved."
        redirect_to(:action => "review", :id => @movie_rating.id)
      end
    end
  end
  
  def preview
    render(:partial => "shared/preview", :locals => {:entity => MovieRating.new(params[:movie_rating])}) if request.xhr?
  end
  
  def show
    @movie = Movie.find_by_id(params[:id])
    unless @movie
      flash[:failure] = "movie not found."
      redirect_to(:action => "index")
      return
    end
    conditions = {:movie_id => @movie.id}
    conditions.store(:user_id, logged_in_user.friends.map { |friend| friend.id }) if 'true' == params[:friends_only] && logged_in_user
    @reviews_pages, @reviews = paginate(:movie_ratings, :conditions => conditions)
    @page_title = "#{@movie.title}"
    render(:layout => false) if request.xhr?
  end
  
  def new
    @movie = Movie.new(params[:movie] ? params[:movie] : nil)
    redirect_to(:action => "new_review", :movie_id => @movie.id) if request.post? && @movie.save
  end
  
  def edit
    @movie = Movie.find_by_id(params[:id]) || Movie.new
    if request.post?
      @movie.attributes = params[:movie]
      redirect_to(:action => "show", :id => @movie.id) and flash[:success] = "movie saved" if @movie.save
    end
  end
  
  auto_complete_for :movie, :title
  
  def search
    if request.get?
      if params[:id]
        if params[:id].size > 0
        search_text = "%#{params[:id]}%"
        @movies = Movie.find(:all, :conditions => ["lower(title) like ?", search_text.downcase]) if search_text
        else
          flash.now[:failure] = "search for something."
        end
      end
    else
      redirect_to(:action => "search", :id => params[:movie][:title])
    end
  end
  
  private
  
  def existing_review?(movie)
    logged_in_user && movie.reviews.map { |review| review.user_id }.include?(logged_in_user.id)
  end
  
end
