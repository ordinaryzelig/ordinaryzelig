module OrdinaryZelig
  
  module HasPrivacy
    
    def self.included(base)
      base.extend OrdinaryZelig::HasPrivacy::ClassMethods
    end
    
    module ClassMethods
      
      def has_privacy
        include OrdinaryZelig::HasPrivacy::InstanceMethods
        has_one :privacy_level, :as => :entity
        before_create :add_privacy_level
      end
      
    end
    
    module InstanceMethods
      
      def set_privacy_level_to(privacy_level_type_id)
        # add if not already added.
        add_privacy_level(privacy_level_type_id)
        # set privacy
        self.privacy_level.privacy_level_type_id = privacy_level_type_id
      end
      
      # add privacy_level if not already added.
      # default level_type to user's privacy_level_type.
      def add_privacy_level(privacy_level_type_id = self.user.privacy_level.privacy_level_type_id)
        self.privacy_level ||= PrivacyLevel.new(:privacy_level_type_id => privacy_level_type_id)
      end
      
    end
    
  end
  
end
