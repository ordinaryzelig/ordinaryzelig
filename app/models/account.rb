class Account < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :season
  
  def pay
    self.amount_paid = self.season.buy_in * self.user.pool_users.for_season(self.season).size
    save
  end
  
end
