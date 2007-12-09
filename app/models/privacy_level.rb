class PrivacyLevel < ActiveRecord::Base
  
  belongs_to :privacy_level_type
  validates_presence_of :privacy_level_type_id
  
  is_polymorphic :skip_validations => true
  
end
