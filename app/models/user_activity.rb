class UserActivity < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :user_activity_type
  validates_presence_of :user_id, :user_activity_type_id, :previous_action_at, :last_action_at
  
  def log!
    now = Time.now.localtime
    self.previous_action_at = self.last_action_at || now
    self.last_action_at = now
    save!
  end
  
end
