class RemoveSeasonTournamentYear < ActiveRecord::Migration
  
  use_two_sided_migration { Group.new RemoveIndex.new(:seasons, :tournament_year, {:name => "seasons_tournament_year_key", :unique => true}),
                                      RemoveColumn.new(:seasons, :tournament_year, :integer) }
  
end
