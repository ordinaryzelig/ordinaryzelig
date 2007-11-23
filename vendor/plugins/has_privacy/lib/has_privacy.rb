module OrdinaryZelig
  
  module HasPrivacy
    
    def self.included(base)
      base.extend OrdinaryZelig::HasPrivacy::ClassMethods
    end
    
    module ClassMethods
      
      def has_privacy
        include OrdinaryZelig::HasPrivacy::InstanceMethods
        has_one :privacy_level, :as => :entity
        before_save :add_privacy_level
        @has_privacy = true
      end
      
      def has_privacy?
        @has_privacy ||= false
      end
      
    end
    
    module InstanceMethods
      
      def set_privacy_level_to(privacy_level_type_id)
        # add if not already added.
        add_privacy_level(privacy_level_type_id)
        # set privacy
        self.privacy_level.privacy_level_type_id = privacy_level_type_id
      end
      
      def set_privacy_level_to!(privacy_level_type_id)
        set_privacy_level_to privacy_level_type_id
        self.privacy_level.save!
      end
      
      private
      
      # add privacy_level if not already added.
      # default level_type to user's privacy_level_type.
      # if this is a user, then set it to 2.
      def add_privacy_level(privacy_level_type_id = self.class == User ? 2 : self.user.privacy_level.privacy_level_type_id)
        self.privacy_level ||= PrivacyLevel.new(:privacy_level_type_id => privacy_level_type_id)
      end
      
    end
    
  end
  
end
