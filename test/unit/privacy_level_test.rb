require File.dirname(__FILE__) + '/../test_helper'

class PrivacyLevelTest < Test::Unit::TestCase
  
  fixtures :privacy_levels, :privacy_level_types, :blogs
  
  def test_scope_out_public
    PrivacyLevelType::TYPES.each do |type, id|
      priv_levels = PrivacyLevel.send "readable_by_#{type}", :all
      assert priv_levels.size > 0
      priv_levels.each { |priv_level| priv_level.privacy_level_type_id == id }
    end
  end
  
end
