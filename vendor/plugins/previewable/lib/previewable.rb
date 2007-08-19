# Previewable

module OrdinaryZelig
  
  module Previewable
    
    def self.included(base)
      base.extend(OrdinaryZelig::Previewable::ClassMethods)
    end
    
    module ClassMethods
      
      def preview_using(preview_variable)
        mod = Module.new
        mod.send('define_method', "preview") { return eval(preview_variable.to_s) }
        include mod
      end
      
    end
    
  end
  
end