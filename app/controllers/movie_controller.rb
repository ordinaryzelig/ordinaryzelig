class MovieController < ApplicationController
  
  before_filter :validate_session, :only => [:new_rating, :edit, :new]
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
  
  def new_rating
    @movie = Movie.find_by_id(params[:movie_id] || params[:movie_rating][:movie_id], :include => :ratings)
    @rating_type = MovieRatingType.find_by_id(params[:rating_type_id] || params[:movie_rating][:movie_rating_type_id])
    @movie_rating = @movie.ratings.detect do |rating|
      params[:rating_type_id].to_i == rating.movie_rating_type_id && rating.user_id == logged_in_user.id
    end || MovieRating.new(:movie_id => @movie.id, :rating_type => @rating_type, :user_id => logged_in_user.id)
    @page_title = "#{@movie.title} - #{@rating_type.name} rating"
    if request.post?
      @movie_rating.attributes = params[:movie_rating]
      if @movie_rating.save
        unless request.xhr?
          flash[:success] = "review saved."
          redirect_to(:action => "review", :id => @movie_rating.id)
        end
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
    redirect_to(:action => "show", :id => @movie.id) if request.post? && @movie.save
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
      if params[:id]
        if params[:id].size > 0
        search_text = "%#{params[:id]}%"
        @movies = Movie.find(:all, :conditions => ["lower(title) like ?", search_text.downcase]) if search_text
        else
          flash.now[:failure] = "search for something."
        end
      end
    else
      redirect_to(:action => "search", :id => params[:search_text])
    end
  end
  
  private
  
  def existing_review?(movie, rating_type_id)
    logged_in_user && movie.ratings.detect { |rating| rating == logged_in_user && rating_type_id == rating.rating_type_id }
  end
  
end
