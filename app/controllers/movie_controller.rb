class MovieController < ApplicationController
  
  before_filter :validate_session, :only => [:edit_rating, :edit, :new]
  ADMIN_ACTIONS = ["edit"]
  
  def index
    flash.keep
    redirect_to(:action => "ratings")
  end
  
  def ratings
    @movies = Movie.by_latest_ratings
  end
  
  def rating
    @rating = MovieRating.find_by_id(params[:id])
    unless @rating
      flash[:failure] = "rating not found."
      redirect_to(:action => "ratings")
      return
    end
    @page_title = @rating.movie.title
  end
  
  # first try to find is when redirected here.
  # second is from post request.
  # the point is to use this method to create, edit, and save.
  def edit_rating
    @rating_type = MovieRatingType.find_by_id(params[:rating_type_id] || params[:movie_rating][:movie_rating_type_id])
    @movie = Movie.find_by_id(params[:movie_id] || params[:movie_rating][:movie_id], :include => :ratings)
    @movie_rating = @movie.ratings.detect do |rating|
      params[:rating_type_id].to_i == rating.movie_rating_type_id && rating.user_id == logged_in_user.id
    end || MovieRating.new(:movie_id => @movie.id, :rating_type => @rating_type, :user_id => logged_in_user.id)
    @page_title = "#{@movie.title} - #{@rating_type.name} rating"
    if request.post?
      @movie_rating.attributes = params[:movie_rating]
      if @movie_rating.save
        unless request.xhr?
          flash[:success] = "rating saved."
          redirect_to(:action => "show", :id => @movie_rating.movie_id)
        end
      end
    end
  end
  
  def preview
    render(:partial => "shared/preview", :locals => {:entity => MovieRating.new(params[:movie_rating])}) if request.xhr?
  end
  
  def show
    if request.get?
      @movie = Movie.find_by_id(params[:id])
      unless @movie
        flash[:failure] = "movie not found."
        redirect_to(:action => "index")
        return
      end
      @page_title = "#{@movie.title}"
      conditions = {:movie_id => @movie.id}
      conditions.store(:user_id, logged_in_user.friends.map { |friend| friend.id }) if 'true' == params[:friends_only] && logged_in_user
      conditions.store(:movie_rating_type_id, params[:movie_rating_type_id]) if params[:movie_rating_type_id]
      @ratings = @movie.ratings.find(:all, :conditions => conditions, :include => [:user, :rating_type])
      @rating_types = MovieRatingType.find(:all)
    else
      redirect_to(:action => "edit_rating", :movie_id => params[:movie_id], :rating_type_id => params[:rating_type_id])
    end
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
  
end
