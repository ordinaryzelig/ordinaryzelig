module OrdinaryZelig
  
  module CanBeSummarized
    
    def self.included(base)
      base.extend OrdinaryZelig::CanBeSummarized::ClassMethods
    end
    
    module ClassMethods
      
      KEYS = [:max, :title, :type, :url, :what, :when, :who]
      
      def can_be_summarized_by(options)
        defaults = {:max => 50,
                    :type => proc { self.class },
                    :url => proc{ {:controller => self.class.to_s.downcase, :action => "show", :id => self.id} },
                    # :when => :created_at,
                    :who => :user}
        mod = Module.new
        options.each { |key, value| mod.send('define_method', "summarize_#{key}", proc_for_option(key, value)) }
        defaults.each { |key, value| mod.send('define_method', "summarize_#{key}", proc_for_option(key, value)) unless mod.method_defined?("summarize_#{key}") }
        KEYS.each { |key, value| mod.send('define_method', "summarize_#{key}", proc { nil }) unless mod.method_defined?("summarize_#{key}") }
        # defaults.
        include mod
        include ActionView::Helpers::TextHelper
      end
      
      private
      
      def proc_for_option(key, value)
        raise "unrecognized key '#{key}'" unless KEYS.include?(key)
        case key
        when :what || "what"
          if value.is_a?(Proc)
            prc = value
          else
            prc = proc { strip_tags(eval("#{value}"))[0..summarize_max] }
          end
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