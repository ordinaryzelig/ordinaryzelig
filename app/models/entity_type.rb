class EntityType < ActiveRecord::Base
  
  def self.entity_class(entity_type_name)
    eval "#{entity_type_name}"
  end
  
  def entity_class
    self.class.entity_class("#{self.name}")
  end
  
end