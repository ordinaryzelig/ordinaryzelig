require File.dirname(__FILE__) + '/../test_helper'

class ReadItemTest < Test::Unit::TestCase
  
  fixtures :read_items
  
  def test_read_by?
    read_item = read_items(:read_blog)
    assert read_item.entity.read_by?(read_item.user)
  end
  
end
