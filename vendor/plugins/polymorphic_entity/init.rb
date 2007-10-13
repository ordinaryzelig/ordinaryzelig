require 'polymorphic_entity'
ActiveRecord::Base.send 'include', OrdinaryZelig::PolymorphicEntity
