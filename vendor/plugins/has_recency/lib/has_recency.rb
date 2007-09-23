module OrdinaryZelig
  
  module HasRecency
    
    def self.included(base)
      base.extend OrdinaryZelig::HasRecency::ClassMethods
    end
    
    module ClassMethods
      
      def has_recency(options = {})
        object_types = [:user_obj, :user_obj_name, :time_obj, :time_obj_name, :block]
        defaults = {:user_obj => :user,
                    :user_obj_name => "#{options[:user_obj] || :user}_id",
                    :time_obj => :created_at,
                    :time_obj_name => options[:time_obj] || :created_at}
        options.each do |key, value|
          raise "unrecognized recency object type '#{key}'." unless object_types.include?(key)
          def_meth key, value
        end
        defaults.each { |key, value| def_meth(key, value) unless method_defined?("recency_#{key}") }
        include OrdinaryZelig::HasRecency::InstanceMethods
        @has_recency = true
        extend RuntimeClassMethods
      end
      
      def def_meth(key, value)
        if key.to_s.include?('_obj_name')
          module_eval <<-END
            def self.recency_#{key}
              #{value.inspect}
            end
          END
        else
          define_method "recency_#{key}_obj", value.is_a?(Proc) ? value : eval("Proc.new { #{value} }")
        end
      end
      private :def_meth
      
      def has_recency?
        @has_recency || false
      end
      
      def is_recent_entity_type?
        RecentEntityType.find(:all).map { |ret| ret.entity_type.entity_class }.include?(self)
      end
      
      module RuntimeClassMethods
        
        def since_scope(time)
          {:find => {:conditions => ["#{table_name}.#{recency_time_obj_name} > ?", time]}}
        end
        
        def users_scope(users)
          {:find => {:conditions => ["#{table_name}.#{recency_user_obj_name} in (?)", users.map(&:id)]}}
        end
        
        def recents(user)
          with_scope since_scope(user.previous_login_at) do
            with_scope users_scope(user.friends) do
              find :all
            end
          end
        end
        
      end
      
    end
    
    module InstanceMethods
      
      # return the date of the reason this model is recent.
      def most_recent_date(user, check_comments_if_any = false)
        recent_obj = most_recent_because_of(user, check_comments_if_any)
        recent_obj.recency_time_obj(user) if recent_obj
      end
      
      # returns the most recent object that is the reason this model is recent.
      # either self or latest recent comment.
      def most_recent_because_of(user, check_comments_if_any = false)
        unless @recent_obj
          # if not already calculated.
          if defined?(recency_block_obj)
            # self-defined block.
            @recent_obj = self if recency_block_obj(user)
          else
            ruo = recency_user_obj(user)
            if ruo && user.considers_friend?(ruo) && user.can_read?(self)
              @recent_obj = self if recency_time_obj(user) >= user.previous_login_at
            end
          end
        end
        # if checking for comments, return most recent object between most recent comment and self.
        @most_recent_of_recent_comments ||= recent_comments(user).last if check_comments_if_any && self.class.can_have_comments?
        if check_comments_if_any
          @max_of_recents ||= [@recent_obj, @most_recent_of_recent_comments].compact.max { |a, b| a.recency_time_obj(user) <=> b.recency_time_obj(user) }
        else
          @recent_obj
        end
      end
      
      def is_recent?(user, check_comments_if_any = false)
        !most_recent_because_of(user, check_comments_if_any).nil?
      end
      
    end
    
  end
  
end
