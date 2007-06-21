require 'checks_for_recency'
ActiveRecord::Base.send 'include', OrdinaryZelig::ChecksForRecency