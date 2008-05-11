user_fixtures =
[
  'users',
  'friendships',
  'user_activities'
]
march_madness_fixtures =
[
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
other_fixtures =
[
  'messages',
  'blogs',
  'entity_types',
  'comments',
  'comment_groups',
  'movies',
  'movie_rating_types',
  'movie_rating_options',
  'movie_ratings',
  'recent_entity_types',
  'privacy_level_types',
  'privacy_levels',
  'read_items'
]
fixtures =
[
  user_fixtures,
  march_madness_fixtures,
  other_fixtures
]
ENV['FIXTURES'] = fixtures.join(',')
