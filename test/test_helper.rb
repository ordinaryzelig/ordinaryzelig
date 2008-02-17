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
  
  def assert_nil_and_assign(obj, attribute, val)
    assert_nil obj.send(attribute)
    obj.send "#{attribute}=", val
  end
  
  def self.test_created_at
    define_method 'test_created_at' do
      obj = new_with_default_attributes
      assert_nil obj.created_at
      obj.save
      assert obj.created_at
    end
  end
  
  def self.defaults_for(model_class, attributes, accessible = [])
    atts = attributes.dup
    define_method 'defaults' do
      atts
    end
    define_method 'new_with_default_attributes' do
      obj = model_class.new(defaults)
      # for defaults that are not accessible, make sure they're nil at first, but then assign them.
      (defaults.keys - accessible).each { |att| assert_nil_and_assign obj, att, defaults[att] }
      obj
    end
    define_method 'test_new_with_default_attributes' do
      obj = new_with_default_attributes
      assert obj.save
      obj
    end
  end
  
  def self.test_mark_as_read(model_class)
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
  end
  
  def self.test_recency
    define_method 'test_recency'do
      user = users(:ten_cent)
      user.previous_login_at =  1.second.ago
      friend = user.friends.first
      obj = new_with_default_attributes
      friend.send("#{obj.class.to_s.tableize}").concat obj
      assert_not obj.new_record?
      privacy_levels_recency_test obj, user if obj.class.has_privacy?
    end
  end
  
  def self.test_summaries(summaries)
    define_method 'test_summaries' do
      obj = test_new_with_default_attributes
      OrdinaryZelig::CanBeSummarized::KEYS.each do |key|
        method = "summarize_#{key}"
        if obj.respond_to?(method)
          assert_not_nil summaries[key], ":#{key} not in summaries"
          assert_equal obj.send(method), summaries[key][obj], "error with 'summarize_#{key}'"
        end
      end
    end
  end
  
end

module Test::Unit::Assertions
  
  def assert_not(condition, message=nil)
    clean_backtrace do
      full_message = build_message(message, '<false> expected but was <?>.\n', condition)
      assert_block(full_message) { false == condition }
    end
  end
  
end
