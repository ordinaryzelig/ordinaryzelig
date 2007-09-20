require 'can_be_marked_as_read'
ActiveRecord::Base.send 'include', OrdinaryZelig::CanBeMarkedAsRead
