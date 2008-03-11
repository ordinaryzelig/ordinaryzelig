class CreatePages < ActiveRecord::Migration
  
  use_two_sided_migration { CreateTable.new :pages do |t|
    t.column :path, :string, {:null => false}
    t.column :title, :string, {:null => false}
    t.column :source, :text, {:null => false}
    t.column :created_at, :datetime, {:null => false}
    t.column :last_updated_at, :datetime
  end }
  
end
