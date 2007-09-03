class UserActivity < ActiveRecord::Base
  
  set_primary_key("user_id")
  belongs_to :user
  
  def log_login!
    now = Time.now.localtime
    self.previous_login_at = self.last_login_at || now
    self.last_login_at = now
    save!
  end
  
end
