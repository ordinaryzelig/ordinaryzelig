class PrivacyLevel < ActiveRecord::Base
  
  belongs_to :privacy_level_type
  validates_presence_of :privacy_level_type_id
  
  is_polymorphic :skip_validations => true
  PrivacyLevelType::TYPES.each do |type, id|
    has_finder "readable_by_#{type}".to_sym, :conditions => {:privacy_level_type_id => id}
  end
  
  def to_s
    self.privacy_level_type.to_s
  end
  
end
