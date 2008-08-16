module LGS
  
  module TestHelperHelpers
    
    def self.included(base)
      base.extend ClassMethods
      base.send 'include', InstanceMethods
    end
    
    module InstanceMethods
      
      # for defaults that are not accessible, make sure they're nil at first, but then assign them.
      def assert_nil_and_assign(obj, attribute, val)
        assert_nil obj.send(attribute)
        obj.send "#{attribute}=", val
      end
      
      # if you're in subject_test, a call to model_fixtures(fixture_name) is equivalent to calling subjects(fixture_name).
      def model_fixtures(fixture_name)
        send self.class.model_class.to_s.tableize, fixture_name
      end
      
      def model_class
        self.class.model_class
      end
      
    end
    
    module ClassMethods
      
      # define a model's defaults and add some methods for easy, DRY creation.
      def defaults(attributes = {}, accessible = [])
        
        atts = attributes.clone
        
        # in a test, you can call defaults to get the default attributes.
        define_method 'default_atts' do
          atts.clone
        end
        
        # builds a new object for this model with the default attributes.
        # will also test that the non-accessible attributes cannot be mass assigned.
        define_method 'new_with_default_attributes' do |*args|
          opts = {}
          if args && args.length > 0 && args[0].class == Hash
            opts = args[0]
          end
          obj_atts = default_atts.merge(opts)
          obj = self.class.model_class.new(obj_atts)
          (obj_atts.keys - accessible).each { |att| assert_nil_and_assign obj, att, defaults[att] } unless accessible.empty?
          obj
        end
        
        # same as new_with_default_attributes but will assert_save! too.
        # this will run automatically because it is prefixed with 'test'.
        define_method 'test_new_with_default_attributes' do |*args|
          obj = new_with_default_attributes(*args)
          assert_save! obj
          obj
        end
        
      end
      
      # given the test name, assume the first part of the class is the name of the model and return its constant.
      # e.g. UserTest => User.
      def model_class
        @model_class ||= to_s.gsub(/Test$|Controller/, '').constantize
      end
      
      # load all fixtures in the same order as they were loaded in environment.rb.
      def all_fixtures
        fixtures *ENV['FIXTURES'].split(',')
      end
      
    end
    
  end
  
end



# add some custom assertions.
module Test::Unit::Assertions
  
  # opposite of assert.
  def assert_not(condition, message=nil)
    full_message = build_message message, "'false' expected but got '#{condition}'"
    assert_block(full_message) { !condition }
  end
  
  # thinkin about scrapping this one.  assert_save! has been much more reliable.
  def assert_save(obj, message=nil)
    full_message = build_message message, "save failed. errors:\n#{obj.errors.full_messages}"
    assert_block(full_message) { obj.save }
  end
  
  # attempt obj.save!.  if it fails, rescue the exception and use it as the flunk message.
  def assert_save!(obj, message=nil)
    full_message = build_message message, "save failed. errors:\n#{obj.errors.full_messages}"
    assert_block(full_message) { obj.save! }
  end
  
  # assert assigns(variable_name) is not nil.
  # return the variable.
  def assert_assigns(variable_name, message=nil)
    full_message = build_message message, "@#{variable_name} not assigned."
    variable = assigns(variable_name)
    assert_block(full_message) { !variable.nil? }
    variable
  end
  
  # ====================================
  # flash assertions.
  
  # assert_flash_error and assert_no_flash_error will check flash object.
  # but they do not work if the controller specifies flash.now since it is discarded after use.
  # so we have assert_flash_tag and assert_no_shown_flash_tag.
  
  def assert_flash_error
    assert(flash[:error])
  end
  
  def assert_no_flash_error
    assert_nil flash[:error], "expected nil flash[:error], got #{flash[:error]}"
  end
  
  def assert_flash_tag(flash_type, msg = nil)
    options = {:tag => 'div', :attributes => {:id => "flash_#{flash_type}"}}
    options.merge :content => msg if msg
    assert_tag options
  end
  
  # either the tag isn't there, or the tag is hidden.
  def assert_no_flash_tag(flash_type)
    options = {:tag => 'div', :attributes => {:id => "flash_#{flash_type}"}}
    assert_no_tag options
  end
  
end
