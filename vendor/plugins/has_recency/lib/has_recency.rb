module OrdinaryZelig
  
  module HasRecency
    
    def self.included(base)
      base.extend OrdinaryZelig::HasRecency::ClassMethods
    end
    
    module ClassMethods
      
      def has_recency(options = {})
        object_types = [:user_obj, :user_obj_name, :time_obj, :time_obj_name]
        defaults = {:user_obj => :user,
                    :user_obj_name => "#{options[:user_obj] || :user}_id",
                    :time_obj => :created_at,
                    :time_obj_name => options[:time_obj] || 'created_at'}
        options.each do |key, value|
          raise "unrecognized recency object type '#{key}'." unless object_types.include?(key)
          def_meth key, value
        end
        defaults.each { |key, value| def_meth(key, value) unless method_defined?("recency_#{key}") }
        include OrdinaryZelig::HasRecency::InstanceMethods
        @has_recency = true
        def self.recents(user, *more_scopes)
          all_scopes = [{:conditions => ["#{table_name}.#{recency_user_obj_name} in (?)", user.friends.map(&:id)]},
                       {:conditions => ["#{table_name}.#{recency_time_obj_name} > ?", user.previous_login_at]}]
          @recents = find_all_with_scopes *(all_scopes + more_scopes)
          @recents.delete_if { |r| user.read_items.entities_since_previous_login.include?(r) }
        end
      end
      
      def has_recency?
        @has_recency || false
      end
      
      def is_recent_entity_type?
        RecentEntityType.find(:all).map { |ret| ret.entity_type.entity_class }.include?(self)
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
