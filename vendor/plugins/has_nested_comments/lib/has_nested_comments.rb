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
      
      def has_comments?
        @has_comments || false
      end
      
    end
    
    module InstanceMethods
      
      def latest_comment
        root_comments.map(&:latest_comment).max { |a, b| a.created_at <=> b.created_at }
      end
      
      def has_comments?
        self.class.has_comments?
      end
      
      def recent_comments(user)
        root_comments.map do |com|
          com.self_and_descendants { |c| c.is_recent?(user) }
        end.flatten
      end
      
    end
    
  end
  
end