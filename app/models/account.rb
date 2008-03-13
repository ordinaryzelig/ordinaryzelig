class Account < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :season
  
  def pay
    self.amount_paid = season.buy_in * user.pool_users.for_season(season).size
    save!
  end
  
end
