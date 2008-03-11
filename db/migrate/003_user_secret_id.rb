class UserSecretId < ActiveRecord::Migration
  
  use_two_sided_migration { AddColumn.new :users, :secret_id, :string, :default => '', :null => false, :unique => true }
  # User.find(:all).each do |user|
  #   if user.secret_id.empty?
  #     user.generate_secret_id
  #     user.save!
  #   end
  # end
  
end
