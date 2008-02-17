module OrdinaryZelig
  
  module CanBeSummarizedBy
    
    def self.included(base)
      base.extend OrdinaryZelig::CanBeSummarizedBy::ClassMethods
    end
    
    KEYS = [:max, :title, :url, :what, :when, :who, :name]
    DEFAULTS = {:url => proc { {:controller => self.class.to_s.downcase, :action => "show", :id => self.id} },
                :who => :user,
                :max => 50}
    
    module ClassMethods
      
      def can_be_summarized_by(options)
        DEFAULTS.each { |key, value| define_method "summarize_#{key}", CanBeSummarizedBy.proc_for_option(key, value) }
        options.each { |key, value| define_method "summarize_#{key}", CanBeSummarizedBy.proc_for_option(key, value) }
      end
      
    end
    
    private
    
    include ActionView::Helpers::TextHelper
    
    def self.proc_for_option(key, value)
      raise "unrecognized key '#{key}'" unless KEYS.include?(key)
      if value.is_a?(Symbol)
        proc do
          val = send value
          if val && key == :what
            max = respond_to?(:summarize_max) ? summarize_max : 50
            val = strip_tags(val)[0..max]
          end
          val
        end
      elsif value.is_a?(Proc)
        value
      else
        prc = proc { value }
      end
    end
    
  end
  
end