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
            # # or if there are comments, check if latest_comment is recent.
            # (method_defined?(:latest_comment) && latest_comment && latest_comment.created_at >= usr.user_activity.previous_login_at)
          end
        end
        false
      end
      
    end
    
  end
  
end