# HasNestedComments

module OrdinaryZelig
  
  module HasNestedComments
    
    def self.included(base)
      base.extend OrdinaryZelig::HasNestedComments::ClassMethods
    end
    
    module ClassMethods
      
      def has_nested_comments
        has_many :comment_groups, :as => :entity
        has_many :root_comments,
                 :class_name => "Comment",
                 :through => :comment_groups,
                 :order => :created_at
        include OrdinaryZelig::HasNestedComments::InstanceMethods
        @has_comments = true
      end
      
      def can_have_comments?
        @has_comments || false
      end
      
    end
    
    module InstanceMethods
      
      def latest_comment
        @latest_comment ||= root_comments.map(&:latest_comment).max { |a, b| a.created_at <=> b.created_at }
      end
      
      def can_have_comments?
        self.class.can_have_comments?
      end
      
      def recent_comments(user, &block)
        comments do |c|
          c.is_recent?(user) && (block.nil? || block.call(c))
        end
      end
      
      def comments(&block)
        @comments ||= root_comments.map do |com|
          com.self_and_descendants { |c| block.nil? || block.call(c) }
        end.flatten
      end
      
    end
    
  end
  
end