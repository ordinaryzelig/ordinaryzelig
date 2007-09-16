class EntityType < ActiveRecord::Base
  
  def entity_class
    Object.const_get to_s.classify
  end
  
  def to_s
    name
  end
  
end