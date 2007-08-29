require "digest/sha1"

class User < ActiveRecord::Base
  
  has_many :pool_users, :order => "season_id"
  has_many :accounts
  has_one :user_activity
  has_many :friendships, :foreign_key => "user_id"
  has_many :friends, :through => :friendships
  has_many :considering_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :considering_friends, :through => :considering_friendships
  has_many :blogs
  has_many :movie_ratings, :order => :created_at, :include => :movie
  
  validates_presence_of :first_name, :last_name, :display_name, :email
  validates_uniqueness_of :email, :message => "is already registered. <a href=\"mailto:help@ordinaryzelig.org\">email me</a> and i'll set you up."
  validates_uniqueness_of :display_name, :message => "is already taken."
  validates_format_of :email, :with => %r{.+@.+\..*}
  validate_on_create :confirm_and_set_password
  
  attr_accessor :unhashed_password
  attr_accessor :confirmation_password
  attr_accessor :needs_password_confirmation
  
  def after_create
    self.user_activity = UserActivity.new
    self.user_activity.log_login!
  end
  
  # return user with matching email and password.
  def authenticate
    authenticated_user = nil
    if @unhashed_password.nil? || @unhashed_password.empty?
      errors.add(nil, "password cannot be blank.")
    end
    if @email.nil? || @email.empty?
      errors.add_on_blank(:email)
    end
    if errors.empty?
      authenticated_user = User.find(:first, :conditions => ["email = ? AND password = ?", *[self.email.downcase, hash(@unhashed_password)]])
      if authenticated_user
        authenticated_user.user_activity ||= UserActivity.new
        authenticated_user.user_activity.log_login!
      else
        errors.add(nil, "authentication failed.")
      end
    end
    authenticated_user
  end
  
  # return master user, who's pics are those that actually happened.
  def User::master
    User.find_by_id(User::master_id)
  end
  
  def User::master_id
    1
  end
  
  def is_admin?
    1 == is_admin
  end
  
  def is_master?
    User::master_id == id
  end
  
  def is_admin_or_master?
    is_admin? || is_master?
  end
  
  # return seasons that user is not participating in.
  def other_seasons
    all = Season.find(:all)
    all - self.pool_users.collect{|pool_user| pool_user.season}
  end
  
  # enter user into pool for season.
  # return resulting PoolUser.
  def enter_pool(season_id, bracket_num)
    # create new pool user.
    pool_user = PoolUser.new(:user_id => self.id, :season_id => season_id, :bracket_num => bracket_num)
    # create pics.
    games = Game.find(:all, :conditions => ["season_id = ?", season_id])
    games.each do |game|
      Pic.new(:pool_user => pool_user, :game => game).save
    end
    # create account if needed.
    Account.new(:user_id => self.id, :season_id => season_id).save unless account(season_id)
    pool_user
  end
  
  def account(season_id)
    self.accounts.detect{|account| season_id == account.season_id}
  end
  
  def User::container(season_id = nil)
    if season_id
      users = User.find(:all, :conditions => ["season_id = ?", season_id], :include => :pool_users, :order => "lower(display_name)")
    else
      users = User.find(:all, :order => default_order_by_string)
    end
    users.reject{|user| 1 == user.is_admin}.map{|user| [user.display_name, user.id]}
  end
  
  def season_pool_users(season_id)
    pool_users.reject{|pool_user| season_id != pool_user.season_id}.sort{|a, b| a.bracket_num <=> b.bracket_num}
  end
  
  def toggle_authorization
    self.is_authorized = 1 - self.is_authorized.to_i
  end
  
  # set password to gonzagasucks.
  # def reset_password
  #   self.password = DEFAULT_PASSWORD
  #   save
  # end
  
  def before_save
    self.email.downcase!
  end
  
  def validate_set_new_password
    confirm_and_set_password
  end
  
  def self.default_order_by_string
    "lower(last_name), lower(first_name), lower(display_name)"
  end
  
  # passed user is in self's friends list.
  def considers_friend?(user)
    friends.include?(user)
  end
  
  # self is in passed user's friends list.
  def is_friend_of?(user)
    user.considers_friend?(self)
  end
  
  # both self and user consider each other friends.
  def is_mutual_friend?(user)
    considers_friend?(user) && is_friend_of?(user)
  end
  
  # users in both friends and considering_friends
  def mutual_friends
    friends.select { |friend| considering_friends.include?(friend) }
  end
  
  def wannabe_friends
    considering_friends.reject { |considering_friend| friends.include?(considering_friend) }
  end
  
  def last_first_display
    "#{last_name}, #{first_name} (#{display_name})"
  end
  
  def first_last_display
    "#{first_name} #{last_name} (#{display_name})"
  end
  
  def last_login_at
    user_activity.last_login_at if user_activity
  end
  
  def previous_login_at
    user_activity.previous_login_at if user_activity
  end
  
  def can_read?(obj)
    obj.summarize_who.is_friend_of?(self)
  end
  
  private
  
  def hash(str)
    Digest::SHA1.hexdigest(str)
  end
  
  def validates_presence_of_passwords
    is_valid = true
    if @unhashed_password.nil? || @unhashed_password.empty?
      errors.add(nil, "password cannot be blank.")
      is_valid = false
    end
    if @confirmation_password.nil? || @confirmation_password.empty?
      errors.add_on_blank("confirmation_password")
      is_valid = false
    end
    is_valid
  end
  
  def confirm_and_set_password
    if @needs_password_confirmation && validates_presence_of_passwords
      hashed_password = hash(@unhashed_password)
      hashed_confirmation_password = hash(@confirmation_password)
      @unhashed_password = nil
      @confirmation_password = nil
      if hashed_password == hashed_confirmation_password
        self.password = hashed_password
      else
        errors.add(nil, "confirmation password does not match.")
      end
    end
  end
  
end