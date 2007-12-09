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
        after_update :save_privacy_level
        validates_associated :privacy_level
        attr_accessible :privacy_level_attributes
      end
      
      def has_privacy?
        @has_privacy ||= false
      end
      
    end
    
    module InstanceMethods
      
      protected
      
      def privacy_level_attributes=(attributes)
        if attributes[:id].blank?
          build_privacy_level(attributes)
        else
          self.privacy_level.attributes = attributes
        end
      end
      
      def save_privacy_level
        self.privacy_level.save
      end
      
    end
    
  end
  
end
