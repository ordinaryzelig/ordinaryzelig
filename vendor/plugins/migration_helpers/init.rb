require 'migration_helpers'
ActiveRecord::Migration.send 'include', LGS::TwoSidedMigration
