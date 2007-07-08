module OrdinaryZelig
  
  module CanBePaginated
    
    def self.included(base)
      base.extend OrdinaryZelig::CanBePaginated::ClassMethods
    end
    
    module ClassMethods
      
      def can_be_paginated(options)
        @can_be_paginated = true
        @pagination_options = options[:options]
        @partial_locals = options[:partial_locals]
        
        def pagination_options
          @pagination_options
        end
        
        def partial_locals
          @partial_locals
        end
        
      end
      
      def can_be_paginated?
        @can_be_paginated || false
      end
      
    end
    
  end
  
end