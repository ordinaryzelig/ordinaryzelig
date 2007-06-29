module OrdinaryZelig
  
  module ChecksForRecency
    
    def self.included(base)
      base.extend OrdinaryZelig::ChecksForRecency::ClassMethods
    end
    
    module ClassMethods
      
      def has_recency(options)
        object_types = [:user, :time]
        # each model that has_recency will include a unique Modules that define recency_user_obj and recency_time_obj.
        mod = Module.new
        options.each do |object_type, object_name|
          raise "unrecognized recency object type '#{object_type}'." unless object_types.include?(object_type)
          eval("mod.send('define_method', 'recency_#{object_type}_obj', Proc.new { #{object_name} })")
        end
        include mod
        # all models that has_recency include OrdinaryZelig::ChecksForRecency::InstanceMethods.
        include OrdinaryZelig::ChecksForRecency::InstanceMethods
        @has_recency = true
      end
      
      def has_recency?
        @has_recency || false
      end
      
      def recents(user, options = {})
        with_scope :find => options do
          find(:all).select do |obj|
            obj if obj.recency_time_obj &&
                   user.previous_login_at &&
                   obj.recency_time_obj >= user.previous_login_at &&
                   obj.recency_time_obj <= Time.now
          end
        end
      end
      
    end
    
    module InstanceMethods
      
      def is_recent?(usr)
        # check if usr is owner
        if recency_user_obj != usr
          # check if usr has user_activity and previous_login_at.
          if usr.user_activity && usr.user_activity.previous_login_at
            # return if recency_time_obj is recent.
            return (recency_time_obj && recency_time_obj >= usr.user_activity.previous_login_at)# ||
          end
        end
        false
      end
      
      def has_recent_activity?(usr)
        is_recent?(usr) || has_comments? ? latest_comment.is_recent?(usr) : false
      end
      
    end
    
  end
  
end