module OrdinaryZelig
  
  module NilIfBlank
    
    def self.included(base)
      base.extend OrdinaryZelig::NilIfBlank::ClassMethods
    end
    
    module ClassMethods
      
      def nil_if_blank(*options)
        symbols = options.empty? ? self.column_names.reject { |name| "id" == name } : options
        symbols.each do |symbol|
          before_validation proc { |obj| obj[symbol] = nil if obj[symbol].blank? }
        end
      end
      
    end
    
  end
  
end
