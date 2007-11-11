class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :path, :string, {:null => false}
      t.column :title, :string, {:null => false}
      t.column :source, :text, {:null => false}
      t.column :created_at, :datetime, {:null => false}
      t.column :last_updated_at, :datetime
    end
  end

  def self.down
    drop_table :pages
  end
end
