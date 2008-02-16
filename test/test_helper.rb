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
  
  def assert_not(condition)
    assert !condition
  end
  
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
  
end
