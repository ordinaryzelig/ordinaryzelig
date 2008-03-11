class Privacy < ActiveRecord::Migration
  
  PrivacyLevelTypes = CreateTable.new :privacy_level_types do |t|
    t.column :name, :string, {:null => false}
  end
  CreatePrivacyLevels = CreateTable.new :privacy_levels do |t|
    t.column :entity_type, :string, {:null => false}
    t.column :entity_id, :integer, {:null => false}
    t.column :privacy_level_type_id, :integer, {:null => false}
  end
  PrivacyLevels = Group.new CreatePrivacyLevels,
                  AddFKey.new(:privacy_levels, :entity_type, {:reference_table => :entity_types, :reference_column => :name}),
                  AddFKey.new(:privacy_levels, :privacy_level_type_id)
  
  use_two_sided_migration { Group.new PrivacyLevelTypes,
                                      PrivacyLevels }
end
