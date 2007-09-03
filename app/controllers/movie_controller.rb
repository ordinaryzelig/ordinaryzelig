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
    unless @rating && @rating.summary
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
    @movie_rating = @movie.existing_rating(logged_in_user.id, @rating_type.id) ||
                    MovieRating.new(:movie_id => @movie.id, :movie_rating_type_id => @rating_type.id, :user_id => logged_in_user.id)
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
      @page_title = "#{@movie.title}"
      conditions = {:movie_id => @movie.id}
      conditions.store(:user_id, logged_in_user.friends.map { |friend| friend.id }) if 'true' == params[:friends_only] && logged_in_user
      conditions.store(:movie_rating_type_id, params[:movie_rating_type_id]) if params[:movie_rating_type_id]
      @ratings = @movie.ratings.select { |rating| rating.explanation || rating.summary }
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
  
  def user_ratings
    @user = User.find_by_id(params[:id], :include => :movie_ratings)
    @page_title = "movie ratings - #{@user.display_name}"
  end
  
end
