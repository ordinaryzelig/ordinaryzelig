class Event < ActiveRecord::Base
  
  belongs_to :creator, :class_name => "User", :foreign_key => "created_by_user_id"
  validates_presence_of :name, :starts_at, :ends_at
  validates_presence_of :created_by_user_id, :message => "creator can't be blank."
  
  def validate
    errors.add(nil, "start time must be before end time.") if starts_at >= ends_at
  end
  
end
