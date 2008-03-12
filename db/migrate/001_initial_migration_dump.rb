class InitialMigrationDump < ActiveRecord::Migration
  
  CreateUsers = CreateTable.new :users do |t|
    t.column :first_name,    :string,  :limit => 50
    t.column :last_name,     :string,  :limit => 50
    t.column :display_name,  :string,  :limit => 50
    t.column :email,         :string,  :limit => 50
    t.column :password,      :string,  :limit => 50
    t.column :is_admin,      :integer
    t.column :is_authorized, :integer
  end
  Users = Group.new CreateUsers,
                    AddIndex.new(:users, :email, :name => :users_email_key, :unique => true),
                    AddIndex.new(:users, :display_name, :name => :users_display_name_key, :unique => true)
  
  CreateFriendships = CreateTable.new :friendships do |t|
        t.column :user_id,    :integer
        t.column :friend_id,  :integer
        t.column :created_at, :datetime
      end
  Friendships = Group.new CreateFriendships,
                          AddIndex.new(:friendships, [:user_id, :friend_id], :name => :user_friend, :unique => true),
                          AddFKey.new(:friendships, :user_id),
                          AddFKey.new(:friendships, :friend_id, {:reference_table => :users})
  
  CreateUserActivities = CreateTable.new :user_activities do |t|
    t.column :user_id,           :integer,  :null => false
    t.column :last_login_at,     :datetime
    t.column :previous_login_at, :datetime
  end
  UserActivities = Group.new CreateUserActivities,
                             AddFKey.new(:user_activities, :user_id)
  CreateSeasons = CreateTable.new :seasons do |t|
    t.column :tournament_year,      :integer
    t.column :tournament_starts_at, :datetime
    t.column :is_current,           :integer
    t.column :max_num_brackets,     :integer,  :default => 1
    t.column :buy_in,               :integer
  end
  Seasons = Group.new CreateSeasons,
                      AddIndex.new(:seasons, :is_current, :name => "seasons_is_current_key", :unique => true),
                      AddIndex.new(:seasons, :tournament_year, :name => "seasons_tournament_year_key", :unique => true)
  
  CreateRegions = CreateTable.new "regions" do |t|
    t.column :name,      :string,  :limit => 30
    t.column :season_id, :integer
    t.column :order_num, :integer
  end
  Regions = Group.new CreateRegions,
                      AddIndex.new(:regions, [:season_id, :order_num], :name => "regions_season_id_key", :unique => true),
                      AddFKey.new(:regions, :season_id)
  
  Rounds = CreateTable.new :rounds do |t|
    t.column :name,   :string,  :limit => 30
    t.column :number, :integer
  end
  
  CreateTeams = CreateTable.new "teams" do |t|
    t.column :name, :string, :limit => 20, :null => false
  end
  Teams = Group.new CreateTeams,
                    AddIndex.new(:teams, :name, :name => "teams_name_key", :unique => true)
  
  CreateGames = CreateTable.new :games do |t|
    t.column :season_id, :integer
    t.column :parent_id, :integer
    t.column :round_id,  :integer
    t.column :region_id, :integer
  end
  Games = Group.new CreateGames,
                    AddFKey.new(:games, :parent_id, {:reference_table => :games}),
                    *[:season_id, :round_id, :region_id].map { |field_name| AddFKey.new(:games, field_name) }
  
  CreatePoolUsers = CreateTable.new :pool_users do |t|
    t.column :season_id,   :integer
    t.column :user_id,     :integer
    t.column :bracket_num, :integer
  end
  PoolUsers = Group.new CreatePoolUsers,
                        AddIndex.new(:pool_users, [:season_id, :user_id, :bracket_num], :name => :pool_users_season_id_key, :unique => true),
                        *[:season_id, :user_id].map { |field_name| AddFKey.new(:pool_users, field_name) }
  
  CreateBids = CreateTable.new :bids do |t|
    t.column :team_id,       :integer
    t.column :seed,          :integer
    t.column :first_game_id, :integer
  end
  Bids = Group.new CreateBids,
                   AddIndex.new(:bids, [:team_id, :first_game_id], :name => "bids_team_id_key", :unique => true),
                   AddFKey.new(:bids, :team_id),
                   AddFKey.new(:bids, :first_game_id, {:reference_table => :games})
  
  CreatePics = CreateTable.new :pics do |t|
    t.column :pool_user_id, :integer
    t.column :game_id,      :integer
    t.column :bid_id,       :integer
  end
  Pics = Group.new CreatePics,
                   AddIndex.new(:pics, [:pool_user_id, :game_id], :name => "pics_pool_user_id_key", :unique => true),
                   *[:pool_user_id, :game_id, :bid_id].map { |field_name| AddFKey.new(:pics, field_name) }
  
  CreateAccounts = CreateTable.new :accounts do |t|
    t.column :user_id,     :integer
    t.column :season_id,   :integer
    t.column :amount_paid, :integer, :default => 0
  end
  Accounts = Group.new CreateAccounts,
             AddIndex.new(:accounts, [:user_id, :season_id], :name => "accounts_user_id_key", :unique => true),
             *[:season_id, :user_id].map { |field_name| AddFKey.new(:accounts, field_name) }
  
  CreateMessages =  CreateTable.new :messages do |t|
    t.column :parent_id,         :integer
    t.column :subject,           :string,   :limit => 100
    t.column :body,              :text
    t.column :posted_by_user_id, :integer
    t.column :posted_at,         :datetime
  end
  Messages = Group.new CreateMessages,
                       AddFKey.new(:messages, :parent_id, {:reference_table => :messages}),
                       AddFKey.new(:messages, :posted_by_user_id, {:reference_table => :users})
   
  CreateBlogs = CreateTable.new :blogs do |t|
    t.column :title,      :string,   :limit => 100
    t.column :body,       :text
    t.column :user_id,    :integer
    t.column :created_at, :datetime
  end
  Blogs = Group.new CreateBlogs,
                    AddFKey.new(:blogs, :user_id)
  
  CreateEntityTyes = CreateTable.new :entity_types do |t|
    t.column :name, :string, :limit => 30
  end
  EntityTypes = Group.new CreateEntityTyes,
                          AddIndex.new(:entity_types, :name, :name => "entity_types_name_key", :unique => true)
  
  CreateComments = CreateTable.new :comments do |t|
    t.column :parent_id,  :integer
    t.column :comment,    :string,   :limit => 1000
    t.column :user_id,    :integer
    t.column :created_at, :datetime
  end
  Comments = Group.new CreateComments,
                       AddFKey.new(:comments, :parent_id, {:reference_table => :comments}),
                       AddFKey.new(:comments, :user_id)
  
  CreateCommentGroups = CreateTable.new :comment_groups do |t|
    t.column :entity_type,     :string,  :limit => 30
    t.column :entity_id,       :integer,               :null => false
    t.column :root_comment_id, :integer
  end
  CommentGroups = Group.new CreateCommentGroups,
                            AddIndex.new(:comment_groups, [:entity_type, :entity_id, :root_comment_id], :name => "comment_groups_entity_type_key", :unique => true),
                            AddFKey.new(:comment_groups, :root_comment_id, {:reference_table => :comments})
  
  CreateMovies = CreateTable.new :movies do |t|
    t.column :title,   :string, :limit => 100, :null => false
    t.column :imdb_id, :string, :limit => 20
  end
  Movies = Group.new CreateMovies,
                     AddIndex.new(:movies, :imdb_id, :name => "movies_imdb_id_key", :unique => true),
                     AddIndex.new(:movies, :title, :name => "movies_title_key", :unique => true)
  
  CreateMovieRatingTypes = CreateTable.new :movie_rating_types do |t|
    t.column :name, :string, :limit => 100, :null => false
  end
  MovieRatingTypes = Group.new CreateMovieRatingTypes,
                               AddIndex.new(:movie_rating_types, :name, :name => "movie_rating_types_name_key", :unique => true)
  
  CreateMovieRatingOptions = CreateTable.new :movie_rating_options do |t|
    t.column :movie_rating_type_id, :integer,               :null => false
    t.column :description,          :string,  :limit => 50, :null => false
    t.column :value,                :integer,               :null => false
  end
  MovieRatingOptions = Group.new CreateMovieRatingOptions,
                                 AddIndex.new(:movie_rating_options, [:movie_rating_type_id, :value], :name => "movie_rating_options_movie_rating_type_id_key", :unique => true),
                                 AddFKey.new(:movie_rating_options, :movie_rating_type_id)
  
  CreateMovieRatings = CreateTable.new :movie_ratings do |t|
    t.column :movie_id,             :integer,                 :null => false
    t.column :movie_rating_type_id, :integer,                 :null => false
    t.column :rating,               :integer,                 :null => false
    t.column :summary,              :string,   :limit => 100
    t.column :explanation,          :text
    t.column :user_id,              :integer,                 :null => false
    t.column :created_at,           :datetime,                :null => false
  end
  MovieRatings = Group.new CreateMovieRatings,
                           AddFKey.new(:movie_ratings, :user_id)
  
  CreateRecentEntityTypes = CreateTable.new :recent_entity_types do |t|
    t.column :entity_type_id, :integer
  end
  RecentEntityTypes = Group.new CreateRecentEntityTypes,
                                AddFKey.new(:recent_entity_types, :entity_type_id)
  
  use_two_sided_migration { Group.new(Users,
                                      Friendships,
                                      UserActivities,
                                      Seasons,
                                      Regions,
                                      Rounds,
                                      Teams,
                                      Games,
                                      PoolUsers,
                                      Bids,
                                      Pics,
                                      Accounts,
                                      Messages,
                                      Blogs,
                                      EntityTypes,
                                      Comments,
                                      CommentGroups,
                                      Movies,
                                      MovieRatingTypes,
                                      MovieRatingOptions,
                                      MovieRatings,
                                      RecentEntityTypes) }
    
end
