module OrdinaryZelig
  
  module CanBeSyndicatedBy
    
    def self.included(base)
      base.extend OrdinaryZelig::CanBeSyndicatedBy::PublicClassMethods
    end
    
    KEYS = [:title, :link, :description, :pubdate, :guid, :author]
    
    module PublicClassMethods
      
      def can_be_syndicated_by(options = {})
        extend OrdinaryZelig::CanBeSyndicatedBy::PrivateClassMethods
        defaults = {
          :title => proc { "new #{self.class}" },
          :link => proc { {:controller => self.class.to_s.downcase, :action => :show, :id => self.id} },
          :description => nil,
          :pubdate => :created_at,
          :guid => proc { "#{self.class}_#{self.id}" },
          :author => :user
        }.freeze
        options.each { |key, value| define_method "syndicate_#{key}", proc_for_option(key, value) }
        defaults.each { |key, value| define_method "syndicate_#{key}", proc_for_option(key, value) unless method_defined?("syndicate_#{key}") }
      end
      
    end
    
    module PrivateClassMethods
      
      private
      
      def proc_for_option(key, value)
        raise "unrecognized key '#{key}'" unless KEYS.include?(key)
        if value.is_a?(String) || value.is_a?(Symbol)
          prc = proc { send "#{value}" }
        elsif value.is_a?(Proc)
          prc = value
        else
          prc = proc { value }
        end
        prc
      end
      
    end
    
  end
  
end