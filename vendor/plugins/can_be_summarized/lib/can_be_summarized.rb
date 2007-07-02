module OrdinaryZelig
  
  module CanBeSummarized
    
    def self.included(base)
      base.extend OrdinaryZelig::CanBeSummarized::ClassMethods
    end
    
    module ClassMethods
      
      def can_be_summarized_by(options)
        defaults = {:type => proc { self.class },
                    :max => 50,
                    :who => :user,
                    :when => :created_at}
        mod = Module.new
        options.each { |key, value| mod.send('define_method', "summarize_#{key}", proc_for_option(key, value)) }
        defaults.each { |key, value| mod.send('define_method', "summarize_#{key}", proc_for_option(key, value)) unless mod.method_defined?("summarize_#{key}") }
        # defaults.
        include mod
      end
      
      private
      
      def proc_for_option(key, value)
        raise "unrecognized key '#{key}'" unless [:what, :title, :who, :when, :max, :type, :url].include?(key)
        case key
        when :what || "what"
          prc = proc { eval("#{value}")[0..summarize_max] }
        else
          if value.is_a?(String) || value.is_a?(Symbol)
            prc = proc { eval("#{value}") }
          elsif value.is_a?(Proc)
            prc = value
          else
            prc = proc { value }
          end
        end
        prc
      end
      
    end
    
  end
  
end