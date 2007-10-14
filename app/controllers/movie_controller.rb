class MovieController < ApplicationController
  
  before_filter :require_authentication, :only => [:edit_rating, :edit, :new]
  ADMIN_ACTIONS = ["edit"]
  
  def index
    flash.keep
    redirect_to(:action => "ratings")
  end
  
  def ratings
    @movies = Movie.by_latest_ratings
    @movies.reject! { |movie| movie.ratings.map { |rating| rating.user_id }.include?(params[:id].to_i) } if params[:id]
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
  
  # first try to find id when redirected here.
  # second is from post request.
  # the point is to use this method to create, edit, and save.
  def edit_rating
    @rating_type = MovieRatingType.find_by_id(params[:rating_type_id])
    @movie = Movie.find_by_id(params[:movie_id])
    existing_rating = @movie.existing_rating(logged_in_user.id, @rating_type.id)
    if existing_rating
      @movie_rating = existing_rating
    else
      @movie_rating = MovieRating.new
      @movie_rating.movie_id = @movie.id
      @movie_rating.movie_rating_type_id = @rating_type.id
      @movie_rating.user_id = logged_in_user.id
    end
    @page_title = "#{@movie.title} - #{@rating_type.name} rating"
    if request.post?
      @movie_rating.attributes = params[:movie_rating]
      if @movie_rating.save
        flash[:success] = "rating saved."
        redirect_to(:action => "show", :id => @movie_rating.movie_id)
      end
    end
  end
  
  def preview
    render(:partial => "shared/preview", :locals => {:entity => MovieRating.new(params[:movie_rating])}) if request.xhr?
  end
  
  def show
    if request.get?
      @movie = Movie.find_by_id(params[:id], :include => {:ratings => [:user, :rating_type]})
      unless @movie
        flash[:failure] = "movie not found."
        redirect_to(:action => "index")
        return
      end
      @page_title = "movie - #{@movie.title}"
      @ratings = @movie.ratings
      @filtered_ratings = @ratings.dup
      # filter_who.
      case params[:filter_who]
      when "friends"
        @filtered_ratings.delete_if { |rating| !logged_in_user.friends.include?(rating.user) }
      when "you"
        @filtered_ratings.delete_if { |rating| logged_in_user != rating.user }
      end if logged_in_user
      # filter type.
      @filtered_ratings.delete_if { |rating| params[:filter_type] != rating.rating_type.name } if params[:filter_type]
      @rating_types = MovieRatingType.find(:all)
    else
      redirect_to(:action => "edit_rating", :movie_id => params[:movie_id], :rating_type_id => params[:rating_type_id])
    end
  end
  
  def new
    @movie = Movie.new(params[:movie])
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
        @search_text = params[:id]
        if @search_text.size > 0
          @movies = Movie.search(@search_text) if @search_text
        else
          flash.now[:failure] = "search for something."
        end
      end
    else
      redirect_to(:action => "search", :id => params[:search_text])
    end
  end
  
  def user_ratings
    @user = User.find_by_id(params[:id], :include => :movie_ratings)
    @page_title = "movie ratings - #{@user.display_name}"
  end
  
end
