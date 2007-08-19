module MovieHelper
  
  def ratings(movie, friend_ratings = false)
    reviews = friend_ratings ? movie.friend_reviews(logged_in_user) : movie.reviews
    if reviews.empty?
      "no reviews"
    else
      "#{movie.average_rating(friend_ratings ? logged_in_user : nil)} out of 5 (#{pluralize(reviews.size, "review")})"
    end
  end
  
end
