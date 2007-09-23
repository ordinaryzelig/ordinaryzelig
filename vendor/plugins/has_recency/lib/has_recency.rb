module OrdinaryZelig
  
  module HasRecency
    
    def self.included(base)
      base.extend OrdinaryZelig::HasRecency::ClassMethods
    end
    
    module ClassMethods
      
      def has_recency(options = [])
        object_types = [:user, :time, :block]
        defaults = {:user => :user, :time => :created_at}
        # each model that has_recency will include a unique Module that defines recency_user_obj and recency_time_obj.
        options.each do |key, value|
          raise "unrecognized recency object type '#{key}'." unless object_types.include?(key)
          def_meth key, value
        end
        defaults.each { |key, value| def_meth(key, value) unless method_defined?("recency_#{key}_obj") }
        include OrdinaryZelig::HasRecency::InstanceMethods
        @has_recency = true
      end
      
      def def_meth(key, value, mod)
        define_method "recency_#{key}_obj", value.is_a?(Proc) ? value : eval("Proc.new { #{value} }")
      end
      private_class_method def_meth
      
      def recents(user)
        find(:all, :include => :user).select { |obj| obj.is_recent?(user) }
      end
      
      def has_recency?
        @has_recency || false
      end
      
      def is_recent_entity_type?
        RecentEntityType.find(:all).map { |ret| ret.entity_type.entity_class }.include?(self)
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
