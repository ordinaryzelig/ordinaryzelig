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
        
        scopes[:friends] = proc { |user| {:conditions => ["#{table_name}.#{recency_user_obj_name} in (?)", user.friends.map(&:id)],
                                          :include => {:user => :friendships}} }
        scopes[:created_at_since_previous_login] = proc { |user| {:conditions => ["#{table_name}.#{recency_time_obj_name} > ?", user.previous_login_at]} }
        scopes[:privacy] = proc { |*users| {:conditions => ["(#{PrivacyLevel.table_name}.privacy_level_type_id = 3 or " <<
                                                            "(#{PrivacyLevel.table_name}.privacy_level_type_id = 2 and " <<
                                                            "#{Friendship.table_name}.friend_id in (?)))", users.map(&:id)],
                                            :include => [:privacy_level, {:user => :friendships}]} }
        
        # default method for finding methods.
        # can overwrite.
        def self.recents(user, *more_scopes)
          all_scopes = [scopes[:friends][user], scopes[:created_at_since_previous_login][user]]
          all_scopes << scopes[:privacy][user] if has_privacy?
          recents = find_all_unread_by_user user, *(all_scopes + more_scopes)
        end
      end
      
      def has_recency?
        @has_recency || false
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
      
      def is_recent?(user)
        user && self.class.recents(user).include?(self)
      end
      
    end
    
  end
  
end
