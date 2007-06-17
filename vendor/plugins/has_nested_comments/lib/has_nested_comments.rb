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
      end
      
    end
    
    module InstanceMethods
      
      def latest_comment
        root_comments.map(&:latest).max { |a, b| a.created_at <=> b.created_at }
      end
      
    end
    
  end
  
end