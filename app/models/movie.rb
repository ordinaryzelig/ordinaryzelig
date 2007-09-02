class Movie < ActiveRecord::Base
  
  has_many :ratings, :class_name => "MovieRating", :order => "created_at desc"
  validates_presence_of :title
  validates_uniqueness_of :title
  
  what_proc = proc do
    ratings_strs = []
    rating_types_uniq.each do |rating_type|
      rating, ratings = average_rating{|rating| rating.rating_type == rating_type}
      ratings_strs << "#{rating_type.name}: #{rating} out of 5 (#{pluralize(ratings, 'rating')})"
    end
    [pluralize(ratings.size, 'rating'), ratings_strs.join("<br>")].join("<br>") << "<br>"
  end
  can_be_summarized_by :title => :title, :what => what_proc, :who => nil, :enable_html => true
  
  has_recency :user => proc { |user| recent_ratings(user).last.user },
              :time => proc { |user| recent_ratings(user).last.created_at },
              :block => proc { |user| !recent_ratings(user).empty? }
  
  def before_save
    self.imdb_id = nil if self.imdb_id.blank?
  end
  
  def self.by_latest_ratings
    movies = find(:all, :include => :ratings, :order => "created_at desc").reject { |movie| movie.ratings.empty? }
  end
  
  # returns rating and number of ratings it was based on.
  def average_rating(&block)
    total = 0
    countable_ratings = block ? ratings.select(&block) : ratings
    countable_ratings.each do |rating|
      total += rating.rating
    end
    average_rating = countable_ratings.empty? ? 0 : (0.0 + total) / countable_ratings.size
    # only 1 decimal.
    [(0.0 + (average_rating * 10).round) / 10, countable_ratings.size]
  end
  
  def rating_types_uniq
    ratings.map { |rating| rating.rating_type }.uniq.sort { |a, b| a.id <=> b.id }
  end
  
  def recent_ratings(user)
    ratings.select { |rating| rating.is_recent?(user) }
  end
  
  def existing_rating(user_id, rating_type_id)
    ratings.find(:first, :conditions => {:movie_rating_type_id => rating_type_id, :user_id => user_id})
  end
  
  def user_ratings(user)
    ratings.select { |rating| user == rating.user }.sort do |a, b|
      if a.user_id == b.user_id
        a.movie_rating_type_id <=> b.movie_rating_type_id
      else
        a.user_id <=> b.user_id
      end
    end
  end
  
end
