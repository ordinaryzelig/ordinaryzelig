class MoreMovieRatingTypes < ActiveRecord::Migration
  TYPES = [['quotability', ['that was a quote?', 'quotes sound vaguely familiar', 'major quotes are recognizable', 'even obscure quotes are recognizable', 'can be used in any conversation and situation.']],
           ['music overall', ['greatful deaf', 'forgettable', 'average', 'very good', 'excellent']],
           ['musical score', ['greatful deaf', 'forgettable', 'average', 'very good', 'excellent']],
           ['soundtrack', ['greatful deaf', 'forgettable', 'average', 'very good', 'excellent']]]
  def self.up
    TYPES.each do |type, descriptions|
      rating_type = MovieRatingType.new(:name => type)
      rating_type.save
      descriptions.each_with_index { |desc, i| MovieRatingOption.new(:movie_rating_type_id => rating_type.id, :description => desc, :value => i + 1).save }
    end
  end
  
  def self.down
    MovieRatingType.find_all_by_name(TYPES.map { |key, val| key }).each &:destroy
  end
end
