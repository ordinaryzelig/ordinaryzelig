module OrdinaryZelig
  
  module NilIfBlank
    
    def self.included(base)
      base.extend OrdinaryZelig::NilIfBlank::ClassMethods
    end
    
    module ClassMethods
      
      def nil_if_blank(*options)
        options.each do |symbol|
          before_validation proc { |obj| obj[symbol] = nil if obj[symbol].blank? }
        end
      end
      
    end
    
  end
  
end
