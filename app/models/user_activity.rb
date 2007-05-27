class UserActivity < ActiveRecord::Base
  
  set_primary_key("user_id")
  belongs_to :user
  
  def log_login!
    self.previous_login_at = self.last_login_at
    self.last_login_at = Time.now.localtime
    save!
  end
  
end
