require 'has_nested_comments'
ActiveRecord::Base.send('include', OrdinaryZelig::HasNestedComments)