module ActiveRecord
  
  module Acts
    
    module Tree
      
      module InstanceMethods
        
        def descendants(&block)
          (children.map { |c| c if block.call(c) } + children.map { |c| c.descendants(&block) }).flatten.compact
        end
        
        def self_and_descendants(&block)
          arr = []
          arr << self if block.call(self)
          arr += descendants(&block)
          arr
        end
        
      end
      
    end
    
  end
  
end
