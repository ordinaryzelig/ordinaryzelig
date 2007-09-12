class InitialMigrationDump < ActiveRecord::Migration

  def self.up
    
    create_table "users", :force => true do |t|
      t.column "first_name",    :string,  :limit => 50
      t.column "last_name",     :string,  :limit => 50
      t.column "display_name",  :string,  :limit => 50
      t.column "email",         :string,  :limit => 50
      t.column "password",      :string,  :limit => 50
      t.column "is_admin",      :integer
      t.column "is_authorized", :integer
    end

    add_index "users", ["email"], :name => "users_email_key", :unique => true
    add_index "users", ["display_name"], :name => "users_display_name_key", :unique => true
    
    create_table "friendships", :force => true do |t|
      t.column "user_id",    :integer
      t.column "friend_id",  :integer
      t.column "created_at", :datetime
    end

    add_index "friendships", ["user_id", "friend_id"], :name => "user_friend", :unique => true
    fkey :friendships, :user_id
    fkey :friendships, :friend_id, :users
    
    create_table "user_activities", :id => false, :force => true do |t|
      t.column "user_id",           :integer,  :null => false
      t.column "last_login_at",     :datetime
      t.column "previous_login_at", :datetime
    end
    
    fkey :user_activities, :user_id
    
    create_table "seasons", :force => true do |t|
      t.column "tournament_year",      :integer
      t.column "tournament_starts_at", :datetime
      t.column "is_current",           :integer
      t.column "max_num_brackets",     :integer,  :default => 1
      t.column "buy_in",               :integer
    end

    add_index "seasons", ["is_current"], :name => "seasons_is_current_key", :unique => true
    add_index "seasons", ["tournament_year"], :name => "seasons_tournament_year_key", :unique => true

    create_table "regions", :force => true do |t|
      t.column "name",      :string,  :limit => 30
      t.column "season_id", :integer
      t.column "order_num", :integer
    end

    add_index "regions", ["season_id", "order_num"], :name => "regions_season_id_key", :unique => true
    fkey :regions, :season_id
    
    create_table "rounds", :force => true do |t|
      t.column "name",   :string,  :limit => 30
      t.column "number", :integer
    end

    create_table "teams", :force => true do |t|
      t.column "name", :string, :limit => 20
    end

    add_index "teams", ["name"], :name => "teams_name_key", :unique => true

    create_table "games", :force => true do |t|
      t.column "season_id", :integer
      t.column "parent_id", :integer
      t.column "round_id",  :integer
      t.column "region_id", :integer
    end
    
    %w{season_id round_id region_id}.each { |field_name| fkey 'games', field_name }
    fkey :games, :parent_id, :games
    
    create_table "pool_users", :force => true do |t|
      t.column "season_id",   :integer
      t.column "user_id",     :integer
      t.column "bracket_num", :integer
    end

    add_index "pool_users", ["season_id", "user_id", "bracket_num"], :name => "pool_users_season_id_key", :unique => true
    %w{season_id user_id}.each { |field_name| fkey 'pool_users', field_name }
    
    create_table "bids", :force => true do |t|
      t.column "team_id",       :integer
      t.column "seed",          :integer
      t.column "first_game_id", :integer
    end

    add_index "bids", ["team_id", "first_game_id"], :name => "bids_team_id_key", :unique => true
    fkey :bids, :team_id
    fkey :bids, :first_game_id, :games
    
    create_table "pics", :force => true do |t|
      t.column "pool_user_id", :integer
      t.column "game_id",      :integer
      t.column "bid_id",       :integer
    end

    add_index "pics", ["pool_user_id", "game_id"], :name => "pics_pool_user_id_key", :unique => true
    %w{pool_user_id game_id bid_id}.each { |field_name| fkey 'pics', field_name }
    
    create_table "accounts", :force => true do |t|
      t.column "user_id",     :integer
      t.column "season_id",   :integer
      t.column "amount_paid", :integer, :default => 0
    end

    add_index "accounts", ["user_id", "season_id"], :name => "accounts_user_id_key", :unique => true
    %w{season_id user_id}.each { |field_name| fkey 'accounts', field_name }

    create_table "messages", :force => true do |t|
      t.column "parent_id",         :integer
      t.column "subject",           :string,   :limit => 100
      t.column "body",              :text
      t.column "posted_by_user_id", :integer
      t.column "posted_at",         :datetime
    end
    
    fkey :messages, :parent_id, :messages
    fkey :messages, :posted_by_user_id, :users
    
    create_table "blogs", :force => true do |t|
      t.column "title",      :string,   :limit => 100
      t.column "body",       :text
      t.column "user_id",    :integer
      t.column "created_at", :datetime
    end
    
    fkey :blogs, :user_id

    create_table "entity_types", :force => true do |t|
      t.column "name", :string, :limit => 30
    end

    add_index "entity_types", ["name"], :name => "entity_types_name_key", :unique => true

    create_table "comments", :force => true do |t|
      t.column "parent_id",  :integer
      t.column "comment",    :string,   :limit => 1000
      t.column "user_id",    :integer
      t.column "created_at", :datetime
    end
    
    fkey :comments, :parent_id, :comments
    fkey :comments, :user_id

    create_table "comment_groups", :force => true do |t|
      t.column "entity_type",     :string,  :limit => 30
      t.column "entity_id",       :integer,               :null => false
      t.column "root_comment_id", :integer
    end

    add_index "comment_groups", ["entity_type", "entity_id", "root_comment_id"], :name => "comment_groups_entity_type_key", :unique => true
    fkey :comment_groups, :root_comment_id, :comments

    create_table "movies", :force => true do |t|
      t.column "title",   :string, :limit => 100, :null => false
      t.column "imdb_id", :string, :limit => 20
    end

    add_index "movies", ["imdb_id"], :name => "movies_imdb_id_key", :unique => true
    add_index "movies", ["title"], :name => "movies_title_key", :unique => true

    create_table "movie_rating_types", :force => true do |t|
      t.column "name", :string, :limit => 100, :null => false
    end

    add_index "movie_rating_types", ["name"], :name => "movie_rating_types_name_key", :unique => true

    create_table "movie_rating_options", :force => true do |t|
      t.column "movie_rating_type_id", :integer,               :null => false
      t.column "description",          :string,  :limit => 50, :null => false
      t.column "value",                :integer,               :null => false
    end
    
    add_index "movie_rating_options", ["movie_rating_type_id", "value"], :name => "movie_rating_options_movie_rating_type_id_key", :unique => true
    fkey :movie_rating_options, :movie_rating_type_id

    create_table "movie_ratings", :force => true do |t|
      t.column "movie_id",             :integer,                 :null => false
      t.column "movie_rating_type_id", :integer,                 :null => false
      t.column "rating",               :integer,                 :null => false
      t.column "summary",              :string,   :limit => 100
      t.column "explanation",          :text
      t.column "user_id",              :integer,                 :null => false
      t.column "created_at",           :datetime,                :null => false
    end
    
    fkey :movie_ratings, :user_id
    
    create_table "recent_entity_types", :force => true do |t|
      t.column "entity_type_id", :integer
    end
    
    fkey :recent_entity_types, :entity_type_id
    
  end

  def self.down
    drop_table :movie_ratings
    drop_table :movie_rating_options
    drop_table :movie_rating_types
    drop_table :movies
    drop_table :blogs
    drop_table :messages
    execute 'drop table comments cascade;'
    drop_table :comment_groups
    drop_table :recent_entity_types
    drop_table :entity_types
    drop_table :accounts
    drop_table :pics
    drop_table :bids
    drop_table :pool_users
    execute 'drop table games cascade;'
    drop_table :teams
    drop_table :rounds
    drop_table :regions
    drop_table :seasons
    drop_table :user_activities
    drop_table :friendships
    drop_table :users
  end

end
