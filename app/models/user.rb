require "digest/sha1"

class User < ActiveRecord::Base
  
  has_many :pool_users, :order => "season_id, bracket_num" do
    def for_season(season)
      self.select { |pu| season.id == pu.season_id }
    end
  end
  has_many :accounts do
    def for_season(season)
      detect { |account| season.id == account.season_id }
    end
  end
  has_one :user_activity
  has_many :friendships, :foreign_key => "user_id"
  has_many :friends, :through => :friendships, :order => "lower(last_name)" do
    def blogs_readable_by(user)
      Blog.with_scopes(Blog.scopes[:friends][user], Blog.scopes[:privacy][user], Blog.scopes[:order_by_created_at]) { Blog.find :all }
    end
    def mutual_friends_of(user)
      self.select { |friend| friend.considers_friend?(user) }
    end
  end
  has_many :considering_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :considering_friends, :through => :considering_friendships, :order => "lower(last_name)"
  has_many :blogs do
    def readable_by(user)
      Blog.with_scopes(scopes[:privacy][user], {:conditions => {:id => map(&:id)}}) { Blog.find :all }
    end
  end
  has_many :movie_ratings, :include => :movie
  has_many :read_items do
    def entities
      map(&:entity)
    end
  end
  
  before_validation_on_create :generate_secret_id
  before_validation_on_create { |user| user.set_password user.unhashed_password}
  
  validates_presence_of :first_name, :last_name, :display_name, :email, :secret_id
  validates_uniqueness_of :email, :message => "is already registered."
  validates_uniqueness_of :display_name, :message => "is already taken."
  validates_format_of :email, :with => %r{.+@.+\..*}
  
  after_create do |user|
    user.build_user_activity
    user.user_activity.log_login!
  end
  
  attr_accessible :email, :first_name, :last_name, :display_name, :unhashed_password
  attr_accessor :unhashed_password
  
  scope_out :non_admin, :conditions => ['display_name not in (?)', ['master bracket', 'admin']]
  
  def self.new_registrant(attributes, confirmation_password)
    user = new attributes
    user.valid?
    user.errors.add nil, "password can't be blank" if user.unhashed_password.blank?
    user.errors.add nil, "passwords don't match" if user.errors.empty? && user.unhashed_password != confirmation_password
    user
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
  
  def self.master
    find master_id
  end
  
  def self.master_id
    1
  end
  
  def is_admin?
    1 == is_admin
  end
  
  def User::container(season_id = nil)
    if season_id
      users = User.find(:all, :conditions => ["season_id = ?", season_id], :include => :pool_users, :order => "lower(display_name)")
    else
      users = User.find(:all, :order => default_order_by_string)
    end
    users.reject{|user| 1 == user.is_admin}.map{|user| [user.display_name, user.id]}
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
    return true if self == obj.recency_user_obj || self.is_admin?
    entity = obj.class.is_polymorphic? ? obj.entity : obj
    if obj.class.has_privacy?
      model_class = (obj.is_a?(Comment) ? obj.entity : obj).class
      entity_privacy_level = model_class.with_scopes(obj.class.scopes[:privacy][self]) { model_class.find :first }
      !entity_privacy_level.nil?
    else
      true
    end
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
    save!
  end
  
  def change_password(old_pword, new_pword, confirmation_pword)
    errors.add(nil, "old password can't be blank") if old_pword.blank?
    errors.add(nil, "new password can't be blank") if new_pword.blank?
    errors.add(nil, "confirmation password can't be blank") if confirmation_pword.blank?
    errors.add(nil, "new passwords don't match") unless new_pword == confirmation_pword
    if hash(old_pword) == password && errors.empty?
      set_password!(new_pword)
    else
      errors.add(nil, 'old password incorrect')
      false
    end
  end
  
  def self.search(search_text)
    find_non_admin(:all,
                   :conditions => ["lower(display_name) like :search_text or " <<
                                   "lower(first_name) like :search_text or " <<
                                   "lower(last_name) like :search_text",
                                   {:search_text => "%#{search_text.downcase}%"}],
                   :order => "last_name, first_name, display_name")
  end
  
  def previous_login_at=(time)
    activity = user_activity
    activity.previous_login_at = time
    activity.save!
    time
  end
  
  private
  
  def hash(str)
    Digest::SHA1.hexdigest(str)
  end
  
end
