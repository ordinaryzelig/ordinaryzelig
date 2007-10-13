module OrdinaryZelig
  
  module PolymorphicEntity
    
    def self.included(base)
      base.extend OrdinaryZelig::PolymorphicEntity::ClassMethods
    end
    
    module ClassMethods
      
      def is_entity_type
        @is_entity_type = true
        include OrdinaryZelig::PolymorphicEntity::InstanceMethods
        def entity_type
          @entity_type ||= EntityType.find_by_name(self.to_s)
        end
      end
      
      def is_entity_type?
        @is_entity_type || false
      end
      
      def is_polymorphic
        @is_polymorphic = true
        belongs_to :entity, :polymorphic => true
        validates_presence_of :entity_type
        validates_presence_of :entity_id
      end
      
      def is_polymorphic?
        @is_polymorphic ||= false
      end
      
    end
    
    module InstanceMethods
      
      def div_id
        "#{self.class}_#{id}"
      end
      
    end
    
  end
  
end
