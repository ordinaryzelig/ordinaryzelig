class ReadItem < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :user_id, :read_at
  
  is_polymorphic
  
  def entity_type_id_pair
    [entity_type, entity_id]
  end
  
end
