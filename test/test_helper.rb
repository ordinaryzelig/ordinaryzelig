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
  
  fixtures :users, :user_activities
  
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
  
  def self.test_mark_as_read
    fixtures :users
    define_method 'test_mark_as_read' do
      b = test_new_with_default_attributes
      user = users(:Surly_Stuka)
      assert model_class.find_all_read_by_user(user).empty?
      b.mark_as_read user
      assert_not model_class.find_all_read_by_user(user).empty?
    end
  end
  
  def self.test_privacy_creation
    fixtures :users
    define_method 'test_privacy_creation' do
      obj = test_new_with_default_attributes
      assert_not_nil obj.privacy_level
    end
  end
  
  def self.test_privacy_level
    define_method 'test_privacy_level' do
      obj = test_new_with_default_attributes
      friend = obj.user.friends.first
      non_friend = User.find(:first, :conditions => ['id not in (?)', obj.user.friends])
      assert friend && non_friend
      assert friend.can_read?(obj)
      assert_not non_friend.can_read?(obj)
    end
  end
  
  def privacy_levels_recency_test(obj, user)
    # not friends, so shouldn't be recent.
    assert_not obj.user.friends.include?(user)
    obj.set_privacy_level! 2
    assert_equal obj.privacy_level.privacy_level_type_id, 2
    assert_not obj.class.recents(user).include?(obj)
    
    # public, should be recent.
    obj.set_privacy_level! 3
    assert_equal obj.privacy_level.privacy_level_type_id, 3
    assert obj.class.recents(user).include?(obj)
    
    # user only, should not be recent.
    obj.set_privacy_level! 1
    assert_equal obj.privacy_level.privacy_level_type_id, 1
    assert_not obj.class.recents(user).include?(obj)
    
    # make friends, should be recent.
    obj.user.friends << user
    obj.set_privacy_level! 2
    assert_equal obj.privacy_level.privacy_level_type_id, 2
    assert obj.class.recents(user).include?(obj)
  end
  
  def self.test_recency
    define_method 'test_recency' do
      user = users(:ten_cent)
      user.set_previous_login_at! 1.second.ago
      friend = user.friends.first
      obj = new_with_default_attributes
      obj.user = friend
      assert obj.save
      if obj.class.has_privacy?
        privacy_levels_recency_test obj, user
      else
        assert obj.class.recents(user).include?(obj)
      end
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
  
end
