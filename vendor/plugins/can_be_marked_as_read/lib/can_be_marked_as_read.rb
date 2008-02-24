module OrdinaryZelig
  
  module CanBeMarkedAsRead
    
    def self.included(base)
      base.extend OrdinaryZelig::CanBeMarkedAsRead::ClassMethods
    end
    
    module ClassMethods
      
      def can_be_marked_as_read(options = {})
        has_many :read_items, :as => :entity
        @can_be_marked_as_read = true
        define_method 'mark_as_read' do |user|
          ReadItem.new(:user_id => user.id, :entity_type => self.class.to_s, :entity_id => id, :read_at => Time.now).save!
        end
        def self.find_all_read_by_user(user)
          ReadItem.find_all_by_entity_type_and_user_id(self.to_s, user.id).map(&:entity)
        end
        def self.find_all_unread_by_user(user, *scopes)
          all = with_scopes(*scopes) { find :all }
          all - find_all_read_by_user(user)
        end
      end
      
      def can_be_marked_as_read?
        @can_be_marked_as_read || false
      end
      
    end
    
  end
  
end
