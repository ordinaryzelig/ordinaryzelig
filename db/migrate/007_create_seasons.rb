class CreateSeasons < ActiveRecord::Migration
  def self.up
    create_table :seasons do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :seasons
  end
end
