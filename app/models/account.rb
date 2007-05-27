class Account < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :season
  
  def pay
    self.amount_paid = self.season.buy_in * self.user.season_pool_users(self.season_id).size
    save
  end
  
end
