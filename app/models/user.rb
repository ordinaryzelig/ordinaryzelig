require "digest/sha1"

class User < ActiveRecord::Base
  
  has_many :pool_users, :order => "season_id"
  has_many :accounts
  has_one :user_activity
  has_many :friendships, :foreign_key => "user_id"
  has_many :friends, :through => :friendships, :order => "lower(last_name)" do
    def blogs(user)
      Blog.find(:all, :conditions => {:user_id => self.map(&:id)}, :order => 'created_at desc').select { |blog| user.can_read?(blog) }
    end
    def mutual_friends_of(user)
      self.select { |friend| friend.considers_friend?(user) }
    end
  end
  has_many :considering_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :considering_friends, :through => :considering_friendships, :order => "lower(last_name)"
  has_many :blogs do
    def readable_by(user)
      self.select { |blog| user.can_read?(blog) }
    end
  end
  has_many :movie_ratings, :include => :movie
  has_many :read_items do
    def entities
      map(&:entity)
    end
    def entities_since_previous_login
      if empty?
        []
      else
        user = first.entity.user
        self.select { |ri| ri.read_at >= user.previous_login_at }.map(&:entity)
      end
    end
  end
  
  validates_presence_of :first_name, :last_name, :display_name, :email, :secret_id
  validates_uniqueness_of :email, :message => "is already registered."
  validates_uniqueness_of :display_name, :message => "is already taken."
  validates_format_of :email, :with => %r{.+@.+\..*}
  
  attr_accessible :email, :first_name, :last_name, :display_name, :unhashed_password, :is_admin
  
  attr_accessor :unhashed_password, :password
  
  def self.new_registrant(attributes, confirmation_password)
    user = new attributes
    user.valid?
    user.errors.add nil, "password can't be blank" if user.unhashed_password.blank?
    user.errors.add nil, "passwords don't match" if user.errors.empty? && user.unhashed_password != confirmation_password
    user
  end
  
  def before_validation_on_create
    generate_secret_id
    set_password unhashed_password
  end
  
  def after_create
    self.user_activity = UserActivity.new
    self.user_activity.log_login!
  end
  
  # return user with matching email and password.
  def authenticate
    authenticated_user = nil
    if @unhashed_password.blank?
      errors.add(nil, "password can't be blank.")
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
  
  def first_last
    "#{first_name} #{last_name}"
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
    obj.recency_user_obj.considers_friend?(self) && (obj.is_a?(Comment) ? can_read?(obj.entity) : true)
  end
  
  def recents
    return @recents if @recents
    if previous_login_at
      @recents = RecentEntityType.find(:all).map(&:entity_type).map do |entity_type|
        entity_type.entity_class.recents(self)
      end.flatten.sort { |a, b| b.recency_time_obj(self) <=> a.recency_time_obj(self) }
      @recents
    else
      @recents = []
    end
  end
  
  def movies_with_ratings
    movie_ratings.sort { |a, b| b.created_at <=> a.created_at }.map { |rating| rating.movie }.uniq
  end
  
  def generate_secret_id
    self.secret_id = "#{id}_" << hash("#{id}#{rand}")
  end
  
  def set_password(pword)
    pword.blank? ? errors.add(nil, "password can't be blank") : self.password = hash(pword)
  end
  
  def set_password!(pword)
    set_password pword
    save
  end
  
  def change_password(old_pword, new_pword, confirmation_pword)
    errors.add(nil, "old password can't be blank") if old_pword.blank?
    errors.add(nil, "new password can't be blank") if new_pword.blank?
    errors.add(nil, "confirmation password can't be blank") if confirmation_pword.blank?
    errors.add(nil, "new passwords don't match") unless new_pword == confirmation_pword
    if hash(old_pword) == password && errors.empty?
      set_password! new_pword
    else
      errors.add(nil, 'old password incorrect')
    end
  end
  
  def self.search(search_text)
    find_all_exclusive({:conditions => ["lower(display_name) like :search_text or " <<
                                        "lower(first_name) like :search_text or " <<
                                        "lower(last_name) like :search_text",
                                        {:search_text => "%#{search_text.downcase}%"}],
                        :order => "last_name, first_name, display_name"})
  end
  
  def self.find_all_exclusive(options = {})
    with_scope :find => options do
      find :all, :conditions => ["#{table_name}.id not in (?)", [1, 29]]
    end
  end
  
  def self.find_exclusive(id, options = {})
    with_scope :find => {:conditions => ["#{table_name}.id = ?", id]} do
      find_all_exclusive(options).first
    end
  end
  
  def valid?
    errors.empty? && super
  end
  
  private
  
  def hash(str)
    Digest::SHA1.hexdigest(str)
  end
  
end
