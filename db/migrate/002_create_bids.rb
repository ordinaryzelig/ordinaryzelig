class CreateBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :bids
  end
end
