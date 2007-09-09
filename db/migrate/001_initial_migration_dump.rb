class InitialMigrationDump < ActiveRecord::Migration

  def self.up

    # ========================================================================================================================
    # users.

    create_table "users", :force => true do |t|
      t.column "first_name",    :string,  :limit => 50, :null => false
      t.column "last_name",     :string,  :limit => 50, :null => false
      t.column "display_name",  :string,  :limit => 50, :null => false, :unique => true
      t.column "email",         :string,  :limit => 50, :null => false, :unique => true
      t.column "password",      :string,  :limit => 50
      t.column "is_admin",      :integer, :null => false, :default => 0
      t.column "is_authorized", :integer, :null => false, :default => 0
    end

    create_table "friendships", :force => true do |t|
      t.column "user_id",    :integer, :references => :users
      t.column "friend_id",  :integer, :references => :users
      t.column "created_at", :datetime
    end

    add_index "friendships", ["user_id", "friend_id"], :name => "user_friend", :unique => true

    create_table "user_activities", :id => false, :force => true do |t|
      t.column "user_id",           :integer,  :null => false, :references => :users
      t.column "last_login_at",     :datetime
      t.column "previous_login_at", :datetime
    end

    # ========================================================================================================================
    # march_madness.

    create_table "seasons", :force => true do |t|
      t.column "tournament_year",      :integer
      t.column "tournament_starts_at", :datetime
      t.column "is_current",           :integer
      t.column "max_num_brackets",     :integer,  :default => 1
      t.column "buy_in",               :integer
    end

    create_table "regions", :force => true do |t|
      t.column "name",      :string
      t.column "season_id", :integer, :references => :seasons
      t.column "order_num", :integer
    end

    add_index "regions", ["season_id", "order_num"], :name => "regions_season_id_key", :unique => true

    create_table "rounds", :force => true do |t|
      t.column "name",   :string
      t.column "number", :integer
    end

    create_table "teams", :force => true do |t|
      t.column "name", :string, :limit => 20, :unique => true
    end

    create_table "games", :force => true do |t|
      t.column "season_id", :integer, :references => :seasons
      t.column "parent_id", :integer, :references => :games
      t.column "round_id",  :integer, :references => :rounds
      t.column "region_id", :integer, :region_id => :regions
    end

    create_table "pool_users", :force => true do |t|
      t.column "season_id",   :integer, :references => :seasons
      t.column "user_id",     :integer, :references => :users
      t.column "bracket_num", :integer
    end

    add_index "pool_users", ["season_id", "user_id", "bracket_num"], :name => "pool_users_season_id_key", :unique => true

    create_table "bids", :force => true do |t|
      t.column "team_id",       :integer, :references => :teams
      t.column "seed",          :integer
      t.column "first_game_id", :integer, :references => :games
    end

    add_index "bids", ["team_id", "first_game_id"], :name => "bids_team_id_key", :unique => true

    create_table "pics", :force => true do |t|
      t.column "pool_user_id", :integer, :references => :pool_users
      t.column "game_id",      :integer, :references => :games
      t.column "bid_id",       :integer, :references => :bids
    end

    add_index "pics", ["pool_user_id", "game_id"], :name => "pics_pool_user_id_key", :unique => true

    create_table "accounts", :force => true do |t|
      t.column "user_id",     :integer, :references => :users
      t.column "season_id",   :integer, :references => :seasons
      t.column "amount_paid", :integer, :default => 0
    end

    add_index "accounts", ["user_id", "season_id"], :name => "accounts_user_id_key", :unique => true

    # ========================================================================================================================
    # entities.

    create_table "entity_types", :force => true do |t|
      t.column "name", :string, :unique => true
    end

    create_table "recent_entity_types", :force => true do |t|
      t.column "entity_type_id", :integer
    end

    # ========================================================================================================================
    # comments.

    create_table "comments", :force => true do |t|
      t.column "parent_id",  :integer, :references => :comments
      t.column "comment",    :string,   :limit => 1000
      t.column "user_id",    :integer, :references => :users
      t.column "created_at", :datetime
    end

    create_table "comment_groups", :force => true do |t|
      t.column "entity_type",     :string
      t.column "entity_id",       :integer,               :null => false
      t.column "root_comment_id", :integer, :references => :comments
    end

    add_index "comment_groups", ["entity_type", "entity_id", "root_comment_id"], :name => "comment_groups_entity_type_key", :unique => true
    execute "alter table comment_groups add constraint comment_groups_entity_type foreign key (entity_type) references entity_types (name);"

    # ========================================================================================================================
    # message_board.

    create_table "messages", :force => true do |t|
      t.column "parent_id",         :integer, :references => :messages
      t.column "subject",           :string,   :limit => 100
      t.column "body",              :text
      t.column "posted_by_user_id", :integer, :references => :users
      t.column "posted_at",         :datetime
    end

    # ========================================================================================================================
    # blogs.

    create_table "blogs", :force => true do |t|
      t.column "title",      :string,   :limit => 100
      t.column "body",       :text
      t.column "user_id",    :integer, :references => :users
      t.column "created_at", :datetime
    end

    # ========================================================================================================================
    # movies.

    create_table "movies", :force => true do |t|
      t.column "title",   :string, :null => false, :unique => true
      t.column "imdb_id", :string, :unique => true
    end

    create_table "movie_rating_types", :force => true do |t|
      t.column "name", :string, :limit => 100, :null => false, :unique => true
    end

    create_table "movie_rating_options", :force => true do |t|
      t.column "movie_rating_type_id", :integer,               :null => false
      t.column "description",          :string, :null => false
      t.column "value",                :integer,               :null => false
    end

    create_table "movie_ratings", :force => true do |t|
      t.column "movie_id",             :integer,                 :null => false
      t.column "movie_rating_type_id", :integer,                 :null => false
      t.column "rating",               :integer,                 :null => false
      t.column "summary",              :string,   :limit => 100
      t.column "explanation",          :text
      t.column "user_id",              :integer,                 :null => false
      t.column "created_at",           :datetime,                :null => false
    end

    add_index "movie_ratings", ["user_id", "movie_id", "movie_rating_type_id"], :name => "user_movie_movie_rating_type", :unique => true

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
