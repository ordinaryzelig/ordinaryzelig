ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
  
  fixtures :users, :user_activities, :friendships
  
  # set session[:user_id] and session[:last_authenticated_action_at]
  def login(user_fixture)
    user = users(user_fixture)
    @request.session[:user_id] = user.id
    @request.session[:last_authenticated_action_at] = Time.now
    user
  end
  
  def logout
    @request.session[:user_id] = nil
    assert_nil @request.session[:user_id]
  end
  
  def reset_controller
    @controller = @controller.class.new
  end
  
  def self.test_created_at
    define_method 'test_created_at' do
      obj = new_with_default_attributes
      assert_nil obj.created_at
      obj.save
      assert obj.created_at
    end
  end
  
  def self.test_summaries(summaries)
    define_method 'test_summaries' do
      obj = test_new_with_default_attributes
      OrdinaryZelig::CanBeSummarizedBy::KEYS.each do |key|
        method = "summarize_#{key}"
        if obj.respond_to?(method)
          assert_not_nil summaries[key], ":#{key} not in summaries"
          assert_equal obj.send(method), summaries[key][obj], "error with 'summarize_#{key}'"
        end
      end
    end
  end
  
  def self.test_syndications(syndications)
    define_method 'test_syndications' do
      obj = test_new_with_default_attributes
      OrdinaryZelig::CanBeSyndicatedBy::KEYS.each do |key|
        method = "syndicate_#{key}"
        if obj.respond_to?(method)
          assert_not_nil syndications[key], ":#{key} not in syndications"
          assert_equal obj.send(method), syndications[key][obj], "error with 'syndicate_#{key}'"
        end
      end
    end
  end
  
  def self.march_madness_fixtures
    [:seasons,
     :regions,
     :rounds,
     :games,
     :users,
     :pool_users,
     :teams,
     :bids,
     :pics,
     :accounts].each { |fixture| fixtures fixture }
  end
  
  def self.movie_fixtures
    fixtures :movie_ratings, :movies, :movie_rating_types, :movie_rating_options
  end
  
  # ======================================================
  # factories.
  
  DEFAULT_ATTRIBUTES = {'blog' => {:title => 'i killed heath ledger',
                                   :body => 'just watched brokeback mountain and dark knight looks badass.',
                                   :user_id => Fixtures.identify(:ten_cent)},
  } unless defined? DEFAULT_ATTRIBUTES
  
end
