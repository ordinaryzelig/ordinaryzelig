class RemoveSeasonTournamentYear < ActiveRecord::Migration
  
  include TwoSidedMigration
  
  ALL = RemoveColumn.new :seasons, :tournament_year, :integer
  
  def self.up
    ALL.up
  end

  def self.down
    All.down
  end
  
end
