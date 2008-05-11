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
      
    end
    
    module ClassMethods
      
      # define a model's defaults and add some methods for easy, DRY creation.
      def defaults(attributes = {}, accessible = [])
        atts = attributes.dup
        # in a test, you can call defaults to get the default attributes.
        define_method 'defaults' do
          atts.dup
        end
        # builds a new object for this model with the default attributes.
        # will also test that the non-accessible attributes cannot be mass assigned.
        define_method 'new_with_default_attributes' do
          obj = self.class.model_class.new(defaults)
          (defaults.keys - accessible).each { |att| assert_nil_and_assign obj, att, defaults[att] } unless accessible.empty?
          obj
        end
        # same as new_with_default_attributes but will assert_save! too.
        # this will run automatically because it is prefixed with 'test'.
        define_method 'test_new_with_default_attributes' do
          obj = new_with_default_attributes
          assert_save! obj
          obj
        end
      end
      
      # given the test name, assume the first part of the class is the name of the model and return its constant.
      # e.g. UserTest => User.
      def model_class
        @model_class ||= to_s.gsub('Test', '').constantize
      end
      
    end
    
  end
  
end



# add some custom assertions.
module Test::Unit::Assertions
  
  # opposite of assert.
  def assert_not(condition, message=nil)
    clean_backtrace do
      full_message = build_message(message, "<false> expected but was <?>.\n", condition)
      assert_block(full_message) { !condition }
    end
  end
  
  # thinkin about scrapping this one.  assert_save! has been much more reliable.
  def assert_save(obj, message=nil)
    clean_backtrace do
      full_message = build_message(message, "save failed. errors: ?\n", obj.errors.full_messages)
      assert_block(full_message) { obj.save }
    end
  end
  
  # attempt obj.save!.  if it fails, rescue the exception and use it as the flunk message.
  def assert_save!(obj, message=nil)
    clean_backtrace do
      full_message = build_message(message, "save failed. errors: ?\n", obj.errors.full_messages)
      assert_block(full_message) { obj.save! }
    end
  rescue Exception => ex
    flunk "save! failed: #{ex.message}"
  end
  
  def assert_assigns(variable_name, message=nil)
    clean_backtrace do
      full_message = build_message(message, "@#{variable_name} not assigned.")
      variable = assigns(variable_name)
      assert_block(full_message) { !variable.nil? }
      variable
    end
  end
  
  def assert_response_true_success
    assert_response :success
    assert flash[:failure].blank?
  end
  
end
