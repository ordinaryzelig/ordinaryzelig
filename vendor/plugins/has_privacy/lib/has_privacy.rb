module OrdinaryZelig
  
  module HasPrivacy
    
    def self.included(base)
      base.extend OrdinaryZelig::HasPrivacy::ClassMethods
    end
    
    module ClassMethods
      
      def has_privacy
        @has_privacy = true
        include InstanceMethods
        has_one :privacy_level, :as => :entity, :dependent => :destroy
        after_save :save_privacy_level
        validates_associated :privacy_level
        attr_accessible :privacy_level_attributes
        PrivacyLevelType::TYPES.each do |type, type_id|
          has_finder "readable_by_#{type}".to_sym, :conditions => ['privacy_level_type_id = ?', type_id], :include => :privacy_level
        end
      end
      
      def has_privacy?
        !!@has_privacy
      end
      
    end
    
    module InstanceMethods
      
      def set_privacy_level!(privacy_level_type_id)
        self.privacy_level.privacy_level_type_id = privacy_level_type_id
        self.privacy_level.save!
      end
      
      # if privacy_level doesn't exist, bulid one.
      # else replace existing attributes.
      def privacy_level_attributes=(attributes)
        if attributes[:id].blank?
          build_privacy_level(attributes)
        else
          self.privacy_level.attributes = attributes if self.privacy_level
        end
      end
      
      # define anybody_can_read? for each privacy level type.
      PrivacyLevelType::TYPES.each do |type, type_id|
        define_method "is_readable_by_#{type}?" do
          type_id == privacy_level.privacy_level_type_id
        end
      end
      
      protected
      
      # add default privacy_level if it doesn't already exist.
      # save it.
      def save_privacy_level
        self.privacy_level_attributes = {:privacy_level_type_id => 2} unless self.privacy_level
        self.privacy_level.save!
      end
      
    end
    
  end
  
end

class Test::Unit::TestCase
  
  def self.privacy_test_suite
    test_privacy_level
    test_has_finder_readable_by
    test_privacy_creation
    test_set_privacy_level!
  end
  
  # test each privacy_level and whether user can_read?.
  def self.test_privacy_level
    define_method 'test_privacy_level' do
      obj = test_new_with_default_attributes
      assert_equal 2, obj.privacy_level.privacy_level_type_id
      # friend can read?
      friend = obj.user.friends.first
      assert_not_nil friend
      assert friend.can_read?(obj)
      # non-friend can read?
      non_friend = User.find(:first, :conditions => ['id not in (?)', obj.user.friends])
      assert_not_nil non_friend
      assert_not obj.user.considers_friend?(non_friend)
      assert_not non_friend.can_read?(obj)
      # private object.
      obj.set_privacy_level! 1
      assert_equal 1, obj.privacy_level.privacy_level_type_id
      assert_not friend.can_read?(obj)
      assert_not non_friend.can_read?(obj)
      # public.
      obj.set_privacy_level! 3
      assert_equal 3, obj.privacy_level.privacy_level_type_id
      assert non_friend.can_read?(obj)
    end
  end
  
  def self.test_has_finder_readable_by
    define_method 'test_readable_by' do
      Blog.readable_by_nobody.each { |blog| assert_equal 1, blog.privacy_level.to_i }
      Blog.readable_by_friends.each { |blog| assert_equal 2, blog.privacy_level.to_i }
      Blog.readable_by_anybody.each { |blog| assert_equal 3, blog.privacy_level.to_i }
    end
  end
  
  # make sure privacy_level gets created.
  def self.test_privacy_creation
    define_method 'test_privacy_creation' do
      obj = test_new_with_default_attributes
      assert_not_nil obj.privacy_level
    end
  end
  
  # test ability to set privacy_level easily.
  def self.test_set_privacy_level!
    define_method 'test_set_privacy_level!' do
      obj = test_new_with_default_attributes
      assert_equal 2, obj.privacy_level.privacy_level_type_id
      obj.set_privacy_level! PrivacyLevelType::TYPES[:nobody]
      assert_equal obj.reload.privacy_level.privacy_level_type_id, 1
    end
  end
  
end
