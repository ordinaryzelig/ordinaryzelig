module OrdinaryZelig
  
  module ChecksForRecency
    
    def self.included(base)
      base.extend OrdinaryZelig::ChecksForRecency::ClassMethods
    end
    
    module ClassMethods
      
      def has_recency(options)
        object_types = [:user, :time, :block]
        # each model that has_recency will include a unique Modules that define recency_user_obj and recency_time_obj.
        mod = Module.new
        options.each do |key, value|
          raise "unrecognized recency object type '#{key}'." unless object_types.include?(key)
          mod.send('define_method', "recency_#{key}_obj", value.is_a?(Proc) ? value : eval("Proc.new { #{value} }"))
        end
        include mod
        include OrdinaryZelig::ChecksForRecency::InstanceMethods
        @has_recency = true
      end
      
      def has_recency?
        @has_recency || false
      end
      
      def recents(user, options = {})
        if user.previous_login_at
          with_scope :find => options do
            find(:all).select { |obj| obj.has_recent_activity?(user) }
          end
        else
          []
        end
      end
      
    end
    
    module InstanceMethods
      
      def is_recent?(user)
        if defined?(recency_block_obj)
          recency_block_obj(user)
        else
          # check if user is owner and is allowed to read it.
          if recency_user_obj != user && user.considers_friend?(recency_user_obj) && user.can_read?(self)
            # check if user has user_activity and previous_login_at.
            if user.previous_login_at
              # return if recency_time_obj is recent.
              return recency_time_obj >= user.previous_login_at
            end
          end
          false
        end
      end
      
      def has_recent_activity?(user)
        is_recent?(user) || (self.class.can_have_comments? && !recent_comments(user).empty?)
      end
      
    end
    
  end
  
end