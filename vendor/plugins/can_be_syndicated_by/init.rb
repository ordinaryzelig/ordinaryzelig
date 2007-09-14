require 'can_be_syndicated_by'
ActiveRecord::Base.send 'include', OrdinaryZelig::CanBeSyndicatedBy
