class AddSessions < ActiveRecord::Migration
  
  CreateSessions = CreateTable.new :sessions do |t|
    t.column :session_id, :string
    t.column :data, :text
    t.column :updated_at, :datetime
  end
  
  use_two_sided_migration { Group.new(CreateSessions,
                                      AddIndex.new(:sessions, :session_id),
                                      AddIndex.new(:sessions, :updated_at)) }
  
end
