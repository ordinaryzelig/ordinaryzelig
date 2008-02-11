require File.dirname(__FILE__) + '/../test_helper'

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
    
    # save and authenticate.
    assert u.save
    assert_equal authenticate(ATTRIBUTES[:email], ATTRIBUTES[:unhashed_password]), u
    
    # secret_id.
    assert u.secret_id
    
    # no duplicates.
    assert_not u.clone.valid?
    
    # destroy this user just for testing purposes
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
    u = User.new(ATTRIBUTES)
    u.valid?
    old_hashed = u.password
    new_password = 'qwer'
    u.change_password(ATTRIBUTES[:unhashed_password], new_password, new_password)
    assert_not_equal old_hashed, u.password
    assert_not authenticate(ATTRIBUTES[:email], ATTRIBUTES[:unhashed_password])
    assert authenticate(ATTRIBUTES[:email], new_password)
  end
  
  # helper methods.
  
  def authenticate(email, password)
    User.new(:email => email, :unhashed_password => password).authenticate
  end
  
end
