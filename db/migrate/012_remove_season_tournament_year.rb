class RemoveSeasonTournamentYear < ActiveRecord::Migration
  
  use_two_sided_migration { RemoveColumn.new :seasons, :tournament_year, :integer }
  
end
