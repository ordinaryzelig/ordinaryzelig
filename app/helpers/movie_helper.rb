module MovieHelper
  
  def rating_link(movie, rating_type)
    rating_obj = movie.ratings.detect { |rating| rating.rating_type == rating_type && rating.user == logged_in_user }
    rating_str = rating_obj && rating_obj.rating > 0 ? rating_obj.rating : "rate it"
    link_to(rating_str, :action => "edit_rating", :movie_id => movie.id, :rating_type_id => rating_type.id)
  end
  
  def rating_str(rating)
    rating > 0 ? rating.to_s : ""
  end
  
end
