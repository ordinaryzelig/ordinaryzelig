require 'has_privacy'
ActiveRecord::Base.send 'include', OrdinaryZelig::HasPrivacy
