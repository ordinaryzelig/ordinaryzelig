module OrdinaryZelig
  
  module CanBeMarkedAsRead
    
    def self.included(base)
      base.extend OrdinaryZelig::CanBeMarkedAsRead::ClassMethods
    end
    
    module ClassMethods
      
      def can_be_marked_as_read(options = {})
        @can_be_marked_as_read = true
        define_method 'mark_as_read' do |user|
          ReadItem.new(:user_id => user.id, :entity_type => self.class.to_s, :entity_id => id, :read_at => Time.now).save!
        end
      end
      
      def can_be_marked_as_read?
        @can_be_marked_as_read || false
      end
      
    end
    
  end
  
end
