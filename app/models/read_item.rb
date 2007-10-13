class ReadItem < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :user_id
  validates_presence_of :read_at
  
  is_polymorphic
  
end
