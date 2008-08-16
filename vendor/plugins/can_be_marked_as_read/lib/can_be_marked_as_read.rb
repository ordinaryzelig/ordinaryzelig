module OrdinaryZelig
  
  module CanBeMarkedAsRead
    
    def self.included(base)
      base.extend OrdinaryZelig::CanBeMarkedAsRead::ClassMethods
    end
    
    module ClassMethods
      
      def can_be_marked_as_read(options = {})
        has_many :read_items, :as => :entity do
          def by(user)
            find :all, :conditions => {:user_id => user.id}
          end
        end
        @can_be_marked_as_read = true
        named_scope :read_by, proc { |user| {:conditions => ["#{ReadItem.table_name}.user_id = ? and " <<
                                                             "#{ReadItem.table_name}.entity_type = ?",
                                                             user.id, self.to_s],
                                            :include => :read_items} }
        define_method 'mark_as_read_by' do |user|
          ReadItem.create!(:user_id => user.id, :entity_type => self.class.to_s, :entity_id => id, :read_at => Time.now)
        end
        define_method 'read_by?' do |user|
          !!ReadItem.find_by_entity_type_and_entity_id_and_user_id(self.class.to_s, self.id, user.id)
        end
      end
      
      def can_be_marked_as_read?
        @can_be_marked_as_read || false
      end
      
    end
    
    module Tests
      
      def can_be_marked_as_read_test_suite
        fixtures :read_items
        test_mark_as_read_by
        test_named_scope_read_by
        test_read_items_by
      end
      
      def test_mark_as_read_by
        define_method 'test_mark_as_read_by' do
          b = test_new_with_default_attributes
          user = users(:Surly_Stuka)
          b.mark_as_read_by user
          assert b.read_by?(user)
        end
      end
      
      def test_named_scope_read_by
        define_method 'test_named_scope_read_by' do
          user = users :ten_cent
          read = self.class.model_class.read_by user
          assert read.size > 0
          read.each { |r| assert r.read_by?(user) }
        end
      end
      
      def test_read_items_by
        define_method 'test_read_items_by' do
          obj = send self.class.model_class.to_s.tableize, :read_by_ten_cent
          user = users(:ten_cent)
          read_items = obj.read_items.by(user)
          assert read_items.size > 0
          read_items.each do |item|
            assert_equal ReadItem, item.class
            assert_equal user.id, item.user_id
          end
        end
      end
      
    end
    
  end
  
end

Test::Unit::TestCase.extend OrdinaryZelig::CanBeMarkedAsRead::Tests
