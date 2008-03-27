require File.dirname(__FILE__) + '/../test_helper'
require "digest/sha1"

class UserTest < Test::Unit::TestCase
  
  fixtures :friendships, :blogs, :privacy_levels
  
  defaults({:first_name => 'john',
           :last_name => 'doe',
           :display_name => 'doej',
           :email => 'doej@asdf.fds',
           :unhashed_password => 'asdf'},
           [:first_name, :last_name, :display_name, :email, :unhashed_password])
  
  def test_user_activity
    assert_not test_new_with_default_attributes.user_activity.new_record?
  end
  
  def test_secret_id
    assert test_new_with_default_attributes.secret_id
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
  
  # def test_recents_at_least_gets_called_without_exceptions(user = nil)
  #   assert (user || users(:ten_cent)).recents_to
  # end
  
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
    # User.non_admin.find(:all, :conditions => ['id not in (?)', found_ids]).select do |user|
    #   assert_not user.first_name.downcase.include?(search_text)
    #   assert_not user.last_name.downcase.include?(search_text)
    #   assert_not user.display_name.downcase.include?(search_text)
    # end
  end
  
  def test_change_secret_id
    u = users(:ten_cent)
    old_secret_id = u.secret_id
    u.generate_secret_id
    assert_not_equal old_secret_id, u.secret_id
  end
  
  # def test_friends_blogs
  #   user = test_new_with_default_attributes
  #   blogs = user.friends.blogs_readable_by(user)
  #   blogs.each do |b|
  #     assert user.considers_friend?(b.user)
  #     assert user.can_read?(b)
  #   end
  # end
  
  # def test_blogs_readable_by
  #   user = users(:ten_cent)
  #   friend = user.friends.first
  #   assert_not_nil friend
  #   blogs_readable_by_friend = user.blogs.select { |b| friend.can_read?(b) }
  #   assert_equal blogs_readable_by_friend.size, user.blogs.readable_by(friend).size
  # end
  
  def test_login_without_user_activity
    user = old_user
    user.log_login
    assert user.user_activity
  end
  
  # def recency_test_suite_with_no_friends
  #   user = old_user
  #   test_recents_at_least_gets_called_without_exceptions
  # end
  
  def test_set_password!
    user = users :ten_cent
    old_pword = user.password.dup
    user.set_password!('poiu')
    assert_not_equal old_pword, user.password
  end
  
  def test_non_admin
    assert_equal User.find(:all).size, User.non_admin.size + 2
  end
  
  def test_can_read?
    blog = Blog.find :first
    # admin.
    admin = users :admin
    assert admin.can_read?(blog)
    # user is owner.
    assert blog.user.can_read?(blog)
    # by friend and has privacy_level of friend.
    blog.set_privacy_level! 2
    assert_equal 2, blog.privacy_level.privacy_level_type_id
    assert blog.user.friends.first.can_read?(blog)
    # by friend but is private.
    blog.set_privacy_level! 1
    assert_equal 1, blog.privacy_level.privacy_level_type_id
    assert_not blog.user.friends.first.can_read?(blog)
    # non friend, non admin, but public.
    blog.set_privacy_level! 3
    assert_equal 3, blog.privacy_level.privacy_level_type_id
    user = User.non_admin.find(:first, :conditions => ['id not in (?)', blog.user.friends.map(&:id)])
    assert_not user.is_friend_of?(blog.user)
    assert user.can_read?(blog)
  end
  
  # ==========================
  # helper methods.
  
  def change_password(user, old_password, new_password, confirmation_password)
    old_hashed = user.password.dup
    user.change_password(old_password, new_password, confirmation_password)
    resulting_password = user.password
    old_hashed != resulting_password
  end
  
  def authenticate(email, password)
    User.new(:email => email, :unhashed_password => password).authenticate
  end
  
  def find(by_field, search_text)
    User.non_admin.find :all, :conditions => ["lower(#{by_field}) like ?", "%#{search_text.downcase}%"]
  end
  
  # no friends, no user_activity.
  def old_user
    user = User.find(:first, :conditions => "id != #{users(:ten_cent).id}")
    assert_nil user.user_activity
    assert user.friends.empty?
    user
  end
  
end
