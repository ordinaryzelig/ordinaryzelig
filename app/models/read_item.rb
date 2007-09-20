class ReadItem < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :entity, :polymorphic => true
  
  validates_presence_of :user_id
  validates_presence_of :entity_type
  validates_presence_of :entity_id
  validates_presence_of :read_at
  
end
