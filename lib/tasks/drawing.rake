namespace :drawing do
  
  desc 'pick a random player that has paid.'
  task :paid_user => :environment do
    user = User.find :first, :conditions => ["#{PoolUser.table_name}.season_id = :season_id and " <<
                                             "amount_paid > 0 and " <<
                                             "#{Account.table_name}.season_id = :season_id",
                                             {:season_id => Season.latest.id}],
                             :include => [:pool_users, :accounts], :order => "random()"
    puts user.first_last
  end
  
end
