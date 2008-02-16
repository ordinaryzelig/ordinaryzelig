class ReadItem < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :user_id, :read_at
  
  is_polymorphic
  
end
