class PageUpdatedAt < ActiveRecord::Migration
  
  use_two_sided_migration { RenameColumn.new(:pages, :last_updated_at, :updated_at) }
  
end
