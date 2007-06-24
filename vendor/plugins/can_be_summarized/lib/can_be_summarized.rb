module OrdinaryZelig
  
  module CanBeSummarized
    
    def self.included(base)
      base.extend OrdinaryZelig::CanBeSummarized::ClassMethods
    end
    
    module ClassMethods
      
      def can_be_summarized_by(options)
        keys = [:what, :title, :who, :when, :max]
        mod = Module.new
        max_characters = 50
        options.each do |key, value|
          raise "unrecognized key '#{key}'" unless keys.include?(key)
          case key
          when :max
            max_characters = value
          else
            case key
            when :what
              proc_str = "Proc.new { #{value}[0..max_summary_characters] }"
            else
              proc_str = "Proc.new { #{value} }"
            end
            eval("mod.send('define_method', 'summarize_#{key}', #{proc_str})")
          end
        end
        eval("mod.send('define_method', 'max_summary_characters', Proc.new { #{max_characters} })")
        include mod
        include OrdinaryZelig::CanBeSummarized::InstanceMethods
      end
      
    end
    
    module InstanceMethods
      
    end
    
  end
  
end