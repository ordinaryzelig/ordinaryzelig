class CreateRoundOneMatchupTemplates < ActiveRecord::Migration
  def self.up
    create_table :round_one_matchup_templates do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :round_one_matchup_templates
  end
end
