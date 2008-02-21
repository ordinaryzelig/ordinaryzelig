require File.dirname(__FILE__) + '/../test_helper'
require "digest/sha1"

class UserTest < Test::Unit::TestCase
  
  fixtures :users
  
  defaults({:first_name => 'john',
           :last_name => 'doe',
           :display_name => 'doej',
           :email => 'doej@asdf.fds',
           :unhashed_password => 'asdf'},
           [:first_name, :last_name, :display_name, :email, :unhashed_password])
  
  def test_user_activity
    # check user_activity.
    user = test_new_with_default_attributes
    assert_not user.user_activity.new_record?
  end
  
  def test_secret_id
    user = test_new_with_default_attributes
    assert user.secret_id
  end
  
  def test_no_duplicates
    assert_not test_new_with_default_attributes.clone.valid?
  end
  
  def test_bad_password_authentication
    assert_nil authenticate(defaults[:email], 'fdsa')
  end
  
  def test_no_admin
    att = defaults.dup
    att[:is_admin] = 1
    u = User.new(att)
    u.save
    assert_not u.is_admin?
  end
  
  def test_recents
    assert users(:ten_cent).recents
  end
  
  def test_generate_secret_id
    u = users(:ten_cent)
    assert_equal u, User.find_by_secret_id(u.secret_id)
  end
  
  def test_set_password
    u = test_new_with_default_attributes
    old_hashed = u.password
    u.set_password! 'fdsafdsa'
    assert_not_equal old_hashed, u.password
  end
  
  def test_change_password
    # smooth.
    new_password = 'qwer'
    u = test_new_with_default_attributes
    assert change_password(u, defaults[:unhashed_password], new_password, new_password)
    # bad password
    assert_not change_password(u,'1234', new_password, new_password)
    # no old password
    assert_not change_password(u,'', new_password, new_password)
    # no new password
    assert_not change_password(u,defaults[:unhashed_password], '', new_password)
    # no confirmation password
    assert_not change_password(u,defaults[:unhashed_password], new_password, '')
    # no matching passwords
    assert_not change_password(u,defaults[:unhashed_password], new_password, '1234')
  end
  
  def change_password(user, old_password, new_password, confirmation_password)
    old_hashed = user.password
    user.change_password(old_password, new_password, confirmation_password)
    resulting_password = user.password
    old_hashed != resulting_password
  end
  
  def test_search
    search_text = 'st'.downcase
    found = User.search search_text
    first_names = find 'first_name', search_text
    last_names = find 'last_name', search_text
    display_names = find 'display_name', search_text
    found_ids = (first_names + last_names + display_names).map(&:id)
    # test whether search found all possibilities.
    assert_equal found.size, found_ids.uniq.size
    # test whether there are any missed possibilities.
    User.find_non_admin(:all, :conditions => ['id not in (?)', found_ids]).select do |user|
      assert_not user.first_name.downcase.include?(search_text)
      assert_not user.last_name.downcase.include?(search_text)
      assert_not user.display_name.downcase.include?(search_text)
    end
  end
  
  def test_change_secret_id
    u = users(:ten_cent)
    old_secret_id = u.secret_id
    u.generate_secret_id
    assert_not_equal old_secret_id, u.secret_id
  end
  
  # ==========================
  # helper methods.
  
  def authenticate(email, password)
    User.new(:email => email, :unhashed_password => password).authenticate
  end
  
  def find(by_field, search_text)
    User.find_non_admin :all, :conditions => ["lower(#{by_field}) like ?", "%#{search_text.downcase}%"]
  end
  
end
