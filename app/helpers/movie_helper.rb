module MovieHelper
  
  def rating_link(movie, rating_type)
    rating_obj = movie.ratings.detect { |rating| rating.rating_type == rating_type && rating.user == logged_in_user }
    rating_str = rating_obj && rating_obj.rating > 0 ? rating_obj.to_s : "rate it"
    rating_obj ? link_to(rating_str, :action => "rating", :id => rating_obj.id) : link_to(rating_str, :action => "edit_rating", :movie_id => movie.id, :rating_type_id => rating_type.id)
  end
  
  # rating + (number of ratings).
  def rating_cell(movie, &block)
    rating, size = movie.average_rating(&block)
    if size > 0
      "#{rating} <span style=\"font-size: 10pt;\">(#{pluralize(size, 'rating')})</span>"
    else
      "&nbsp;"
    end
  end
  
  def filtered_background_color(rating_type, who)
    type_filtered = params[:filter_type]
    who_filtered = params[:filter_who]
    type_matches = params[:filter_type] == rating_type.name
    who_matches = params[:filter_who] == who
    return unless type_matches || who_matches
    if type_filtered && who_filtered && type_matches && who_matches ||
       type_filtered && type_matches && !who_filtered ||
       who_filtered && who_matches && !type_filtered
      'background: lightblue;'
    end
  end
  
end
