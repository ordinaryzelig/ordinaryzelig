class EntityType < ActiveRecord::Base
  
  def entity_class
    Object.const_get name
  end
  
  def to_s
    self.name
  end
  
end
