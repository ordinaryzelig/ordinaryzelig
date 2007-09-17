class UserSecretId < ActiveRecord::Migration
  def self.up
    add_column :users, :secret_id, :string, :default => '', :null => false, :unique => true
    User.find(:all).each do |user|
      if user.secret_id.empty?
        user.generate_secret_id
        user.save!
      end
    end
  end

  def self.down
    remove_column :users, :secret_id
  end
end
