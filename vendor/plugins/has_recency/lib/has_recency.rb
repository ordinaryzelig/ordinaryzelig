module OrdinaryZelig
  
  module ChecksForRecency
    
    def self.included(base)
      base.extend OrdinaryZelig::ChecksForRecency::ClassMethods
    end
    
    module ClassMethods
      
      def has_recency(options)
      object_types = [:user, :time]
        options.each do |object_type, object_name|
          raise "unrecognized recency object type '#{object_type}'." unless object_types.include?(object_type)
          raise "unrecognized column '#{object_name}'." unless column_names.include?(object_name.to_s)
          module_eval <<-END
            def recency_#{object_type}_obj_name
              '#{object_name}'
            end
          END
        end
        include OrdinaryZelig::ChecksForRecency::InstanceMethods
      end
      
    end
    
    module InstanceMethods
      
      def is_recent?(user)
        # check if user is owner
        recency_user_obj = eval "#{recency_user_obj_name}"
        if recency_user_obj != user
          # check if user has user_activity and previous_login_at.
          if user.user_activity && user.user_activity.previous_login_at
            # return if recency_time_obj is recent.
            eval "recency_time_obj = #{recency_time_obj_name}"
            recency_time_obj >= user.user_activity.previous_login_at ||
            # or if there are comments, check if latest_comment is recent.
            (method_defined?(:latest_comment) && latest_comment && latest_comment.created_at >= user.user_activity.previous_login_at)
          end
        end
      end
      
    end
    
  end
  
end