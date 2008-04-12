module OrdinaryZelig
  
  module HasRecency
    
    def self.included(base)
      base.extend OrdinaryZelig::HasRecency::ClassMethods
    end
    
    module ClassMethods
      
      def has_recency(object_declarations = {})
        
        object_types = [:user_obj, :user_obj_name, :time_obj, :time_obj_name]
        defaults = {:user_obj => :user,
                    :user_obj_name => "#{object_declarations[:user_obj] || :user}_id",
                    :time_obj => :created_at,
                    :time_obj_name => object_declarations[:time_obj] || 'created_at'}
        object_declarations.each do |key, value|
          raise "unrecognized recency object type '#{key}'." unless object_types.include?(key)
          def_meth key, value
        end
        defaults.each { |key, value| def_meth(key, value) unless method_defined?("recency_#{key}") }
        include OrdinaryZelig::HasRecency::InstanceMethods
        @has_recency = true
        
        has_finder :by_friends_of, proc { |user| {:conditions => {:user_id => user.friends.map(&:id)}} }
        has_finder :by_mutual_friends_of, proc { |user| {:conditions => {:user_id => user.mutual_friends.map(&:id)}} }
        has_finder :by_considering_friends_of, proc { |user| {:conditions => {:user_id => user.considering_friends.map(&:id)}} }
        has_finder :since_previous_login, proc { |user| {:conditions => ["#{table_name}.#{recency_time_obj_name} > ?", user.previous_login_at],
                                                         :order => "#{table_name}.created_at desc" } }
        # default method for finding recents.
        def self.recents_to(user)
          since_previous_login(user).find readable_by(user)
        end
        
        def self.readable_by(user)
          readable = by_friends_of(user)
          if has_privacy?
            readable = readable.readable_by_anybody
            readable += by_mutual_friends_of(user).readable_by_friends
          end
          readable
        end
        
      end
      
      def has_recency?
        !!@has_recency
      end
      
      private
      
      def def_meth(key, value)
        if key.to_s.include?('_obj_name')
          module_eval <<-END
            def self.recency_#{key}
              #{value.inspect}
            end
          END
        else
          define_method "recency_#{key}", value.is_a?(Proc) ? value : eval("Proc.new { #{value} }")
        end
      end
      
    end
    
    module InstanceMethods
      
      # false if user is nil.
      # false if user is owner.
      # false unless user.can_read?
      # true if object was made since user's last_login_at
      def is_recent_to?(user)
        return false unless user
        return false if user == recency_user_obj
        return false if self.class.has_privacy? && !user.can_read?(self)
        return user.last_login_at <= self.recency_time_obj
      end
      
    end
    
  end
  
end

class Test::Unit::TestCase
  
  def self.recency_test_suite
    test_is_recent_to?
    test_has_finder_by_friends_of
    test_has_finder_by_mutual_friends_of
    test_has_finder_since_previous_login
    test_recents_to
    test_readable_by
  end
  
  def self.test_is_recent_to?
    define_method 'test_is_recent_to?' do
      obj = test_new_with_default_attributes
      # no user.
      assert_not obj.is_recent_to?(nil)
      # owner.
      assert_not obj.is_recent_to?(obj.user)
      
      set_user_previous_login_at_before obj.user, obj
      
      # friends and privacy.
      if obj.class.has_privacy?
        privacy_levels_recency_test obj
      else
        user = obj.user.mutual_friends.first
        assert_not_nil user, "#{obj.user.display_name} has no mutual friends"
        assert obj.is_recent_to?(user)
      end
    end
  end
  
  def self.test_has_finder_by_friends_of
    define_method 'test_has_finder_by_friends_of' do
      user = users :ten_cent
      objs = model_class.by_friends_of(user)
      assert objs.size > 0, "no #{model_class} found by friends of"
      objs.each do |obj|
        assert obj.user.is_friend_of?(user)
      end
    end
  end
  
  def self.test_has_finder_by_mutual_friends_of
    define_method 'test_has_finder_by_mutual_friends_of' do
      user = users :ten_cent
      objs = model_class.by_mutual_friends_of(user)
      assert objs.size > 0, "no #{model_class} found by mutual friend"
      objs.each do |obj|
        assert obj.user.is_mutual_friends_with?(user)
      end
    end
  end
  
  def self.test_has_finder_since_previous_login
    define_method 'test_has_finder_since_previous_login' do
      user = users :ten_cent
      objs = model_class.since_previous_login(user)
      assert objs.size > 0, "no #{model_class} found since previous login"
      objs.each do |obj|
        assert obj.created_at >= user.previous_login_at
      end
    end
  end
  
  def self.test_recents_to
    define_method 'test_recents_to' do
      user = users :ten_cent
      objs = model_class.recents_to user
      assert objs.size > 0, "no #{model_class} recents found"
      objs.each { |obj| assert user.can_read?(obj) }
    end
  end
  
  def self.test_readable_by
    define_method 'test_readable_by' do
      user = users :Surly_Stuka
      readable = model_class.readable_by(user)
      assert readable.size > 0
      readable.each do |r|
        assert user.can_read?(r)
      end
    end
  end
  
  # ===========================================
  # helpers.
  
  def set_user_previous_login_at_before(user, obj)
    user.set_previous_login_at! obj.created_at - 1.minute
    assert user.previous_login_at < obj.created_at
  end
  
  def privacy_levels_recency_test(obj)
    user = obj.user.mutual_friends.first
    set_user_previous_login_at_before user, obj
    
    # not friends, so shouldn't be recent.
    obj.user.friends.delete user
    assert_not obj.user.friends.include?(user)
    obj.set_privacy_level! 2
    assert_equal obj.privacy_level.privacy_level_type_id, 2
    assert_not obj.is_recent_to?(user)
    
    # public, should be recent.
    obj.set_privacy_level! 3
    assert_equal obj.privacy_level.privacy_level_type_id, 3
    assert obj.is_recent_to?(user)
    
    # user only, should not be recent.
    obj.set_privacy_level! 1
    assert_equal obj.privacy_level.privacy_level_type_id, 1
    assert_not obj.is_recent_to?(user)
    
    # make friends, should be recent.
    obj.user.friends << user
    obj.set_privacy_level! 2
    assert_equal obj.privacy_level.privacy_level_type_id, 2
    assert obj.is_recent_to?(user)
    
    # recents_to.
    assert obj.class.recents_to(user).include?(obj)
  end
  
end
