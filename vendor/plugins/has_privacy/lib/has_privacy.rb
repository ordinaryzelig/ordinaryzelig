module OrdinaryZelig
  
  module HasPrivacy
    
    def self.included(base)
      base.extend OrdinaryZelig::HasPrivacy::ClassMethods
    end
    
    module ClassMethods
      
      def has_privacy
        include OrdinaryZelig::HasPrivacy::InstanceMethods
        has_one :privacy_level, :as => :entity, :dependent => :destroy
        before_save :add_privacy_level
        @has_privacy = true
      end
      
      def has_privacy?
        @has_privacy ||= false
      end
      
    end
    
    module InstanceMethods
      
      # add privacy_level if not already added.
      # default privacy_level_type_id to 2 if not already set.
      def add_privacy_level(privacy_level_type_id = @privacy_level_type_id || 2)
        self.privacy_level ||= PrivacyLevel.new(:privacy_level_type_id => privacy_level_type_id)
      end
      
    end
    
  end
  
end
