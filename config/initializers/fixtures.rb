FIXTURES = {}

FIXTURES[:user] = [
  'users',
  'friendships',
  'user_activities'
]

FIXTURES[:march_madness] = [
  'seasons',
  'regions',
  'rounds',
  'teams',
  'games',
  'pool_users',
  'bids',
  'pics',
  'accounts'
]

FIXTURES[:movie] = [
  'movies',
  'movie_rating_types',
  'movie_rating_options',
  'movie_ratings',
]

FIXTURES[:other_fixtures] = [
  'messages',
  'blogs',
  'entity_types',
  'comments',
  'comment_groups',
  'recent_entity_types',
  'privacy_level_types',
  'privacy_levels',
  'read_items'
]

ENV['FIXTURES'] = [:user, :march_madness, :movie, :other].map { |group| FIXTURES[group] }.flatten.join(',')
