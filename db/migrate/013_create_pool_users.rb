class CreatePoolUsers < ActiveRecord::Migration
  def self.up
    create_table :pool_users do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :pool_users
  end
end
