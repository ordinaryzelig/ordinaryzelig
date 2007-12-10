class PageUpdatedAt < ActiveRecord::Migration
  def self.up
    rename_column :pages, :last_updated_at, :updated_at
  end

  def self.down
    rename_column :pages, :updated_at, :last_updated_at
  end
end
