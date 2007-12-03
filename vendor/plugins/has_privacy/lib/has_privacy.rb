module OrdinaryZelig
  
  module HasPrivacy
    
    def self.included(base)
      base.extend OrdinaryZelig::HasPrivacy::ClassMethods
    end
    
    module ClassMethods
      
      def has_privacy
        @has_privacy = true
        include InstanceMethods
        has_one :privacy_level, :as => :entity, :dependent => :destroy
        before_save :add_privacy_level
        after_update :save_privacy_level
        validates_associated :privacy_level
        attr_accessible :privacy_level_attributes
      end
      
      def has_privacy?
        @has_privacy ||= false
      end
      
    end
    
    module InstanceMethods
      
      # add privacy_level if not already added.
      # default privacy_level_type_id to 2 if not already set.
      def add_privacy_level(privacy_level_type_id = 2)
        # self.privacy_level ||= build_privacy_level(:privacy_level_type_id => privacy_level_type_id)
      end
      
      def privacy_level_attributes=(attributes)
        if self.privacy_level && self.privacy_level.new_record?
          self.privacy_level.attributes = attributes
        else
          build_privacy_level(attributes)
        end
      end
      
      def save_privacy_level
        self.privacy_level.save
      end
      
    end
    
  end
  
end
