require File.dirname(__FILE__) + '/../test_helper'

class ReadItemTest < ActiveSupport::TestCase
  
  fixtures :read_items
  
  def test_read_by?
    read_item = read_items(:read_blog)
    assert read_item.entity.read_by?(read_item.user)
  end
  
  def test_entity_type_id_pair
    assert_equal ['Blog', Fixtures.identify(:read_by_ten_cent)], read_items(:read_blog).entity_type_id_pair
  end
  
end
