require File.dirname(__FILE__) + '/../test_helper'
require "digest/sha1"

class UserTest < Test::Unit::TestCase
  
  fixtures :users
  
  ATTRIBUTES = {:first_name => 'john',
                :last_name => 'doe',
                :display_name => 'ningj',
                :email => 'ningj@asdf.fds',
                :unhashed_password => 'asdf'}
  
  def test_registration
    # smooth registration.
    u = User.new_registrant(ATTRIBUTES, ATTRIBUTES[:unhashed_password])
    assert u.valid?
    
    # validations.
    ATTRIBUTES.inject({}) do |filled_out_fields, attribute|
      field_name, val = attribute
      filled_out_fields[field_name] = val
      u = User.new filled_out_fields
      if filled_out_fields.size == ATTRIBUTES.size
        assert u.valid?
      else
        assert_not u.valid?
      end
      filled_out_fields
    end
    # save.
    assert u.save
    # check user_activity.
    assert_not u.user_activity.new_record?
    assert u.previous_login_at > 10.seconds.ago
    # authenticate.
    assert_equal authenticate(ATTRIBUTES[:email], ATTRIBUTES[:unhashed_password]), u
    # secret_id.
    assert u.secret_id
    # no duplicates.
    assert_not u.clone.valid?
    # destroy this user just for testing purposes.
    u.destroy
  end
  
  def test_bad_password_authentication
    assert_not authenticate(ATTRIBUTES[:email], 'fdsa')
  end
  
  def test_no_admin
    att = ATTRIBUTES
    att[:is_admin] = 1
    u = User.new(att)
    u.save
    assert_not u.is_admin?
  end
  
  def test_recents_works
    assert users(:ten_cent).recents
  end
  
  def test_generate_secret_id
    u = users(:ten_cent)
    assert_equal u, User.find_by_secret_id(u.secret_id)
  end
  
  def test_set_password
    u = users :Stephanie
    old_hashed = u.password
    u.set_password! 'asdf'
    assert_not_equal old_hashed, u.password
  end
  
  def test_change_password
    # smooth.
    new_password = 'qwer'
    assert change_password(ATTRIBUTES[:unhashed_password], new_password, new_password)
    # bad password
    assert_not change_password('1234', new_password, new_password)
    # no old password
    assert_not change_password('', new_password, new_password)
    # no new password
    assert_not change_password(ATTRIBUTES[:unhashed_password], '', new_password)
    # no confirmation password
    assert_not change_password(ATTRIBUTES[:unhashed_password], new_password, '')
    # no unmatching passwords
    assert_not change_password(ATTRIBUTES[:unhashed_password], new_password, '1234')
  end
  
  def change_password(old_password, new_password, confirmation_password)
    u = User.new(ATTRIBUTES)
    assert u.save
    old_hashed = u.password
    u.change_password(old_password, new_password, confirmation_password)
    resulting_password = u.password
    u.destroy and return old_hashed != resulting_password
  end
  
  def test_search
    search_text = 'st'.downcase
    found = User.search search_text
    first_names = find 'first_name', search_text
    last_names = find 'last_name', search_text
    display_names = find 'display_name', search_text
    found_ids = (first_names + last_names + display_names).map(&:id)
    assert_equal found.size, found_ids.uniq.size
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
  
  def find(by_field, search_text)
    User.find_non_admin :all, :conditions => ["lower(#{by_field}) like ?", "%#{search_text.downcase}%"]
  end
  
  # ==========================
  # helper methods.
  
  def authenticate(email, password)
    User.new(:email => email, :unhashed_password => password).authenticate
  end
  
end
