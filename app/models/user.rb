require "digest/sha1"

class User < ActiveRecord::Base
  
  has_many :pool_users, :order => "season_id, bracket_num" do
    def for_season(season)
      self.select { |pu| season.id == pu.season_id }
    end
    def for_season_and_bracket_num(season, bracket_num)
      pool_users = for_season(season)
      pool_users.detect { |pool_user| bracket_num == pool_user.bracket_num } || pool_users.first
    end
  end
  has_many :accounts do
    def for_season(season)
      detect { |account| season.id == account.season_id }
    end
  end
  has_one :user_activity
  delegate :previous_login_at, :last_login_at, :to => :user_activity
  has_many :friendships, :foreign_key => "user_id"
  has_many :friends, :through => :friendships, :order => "lower(last_name)"
  has_many :considering_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :considering_friends, :through => :considering_friendships, :order => "lower(last_name)"
  has_many :blogs
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
  
  named_scope :non_admin, :conditions => ['display_name not in (?)', ['master bracket', 'admin']]
  
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
    errors.add(nil, "password can't be blank.") if @unhashed_password.blank?
    errors.add_on_blank(:email) if @email.nil? || @email.empty?
    if errors.empty?
      authenticated_user = User.find(:first, :conditions => ["lower(email) = ? AND password = ?", *[self.email.downcase, hash(@unhashed_password)]])
      if authenticated_user
        authenticated_user.log_login
      else
        errors.add(nil, "authentication failed.")
      end
    end
    authenticated_user
  end
  
  def log_login
    self.user_activity ||= UserActivity.new
    self.user_activity.log_login!
  end
  
  def self.master
    @master ||= find_by_display_name 'master bracket'
  end
  
  def self.master_id
    master.id
  end
  
  def is_admin?
    1 == is_admin
  end
  
  def User::container(season_id = nil)
    if season_id
      users = User.find(:all, :conditions => ["#{PoolUser.table_name}.season_id = ?", season_id], :include => :pool_users, :order => "lower(display_name)")
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
  def is_mutual_friends_with?(user)
    considers_friend?(user) && is_friend_of?(user)
  end
  
  def mutual_friends
    self.class.find :all,
                    :conditions => ["#{self.class.table_name}.id in (?) and #{Friendship.table_name}.friend_id = ?", friends.map(&:id), id],
                    :include => :friendships
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
    
  # this user can read if:
  #   is owner.
  #   is admin.
  #   entity doesn't have privacy.
  #   entity's privacy level is public.
  #   entity's privacy level is friends and this is a friend of owner.
  # otherwise, cannot.
  def can_read?(obj)
    return true if self.is_admin?
    return true if self == obj.user
    entity = obj.is_a?(Comment) ? obj.entity : obj
    return true unless entity.class.has_privacy?
    return true if entity.is_readable_by_anybody?
    return true if entity.is_readable_by_friends? && obj.user.considers_friend?(self)
    
    # reason ||= 'not admin' unless self.is_admin?
    # reason ||= 'owner' unless self == obj.user
    # entity = obj.is_a?(Comment) ? obj.entity : obj
    # reason ||= 'no privacy' unless entity.class.has_privacy?
    # reason ||= 'not readable by anybody' unless entity.is_readable_by_anybody?
    # reason ||= 'not readable by friends' if entity.is_readable_by_friends? && obj.user.considers_friend?(self)
    # raise reason if reason
    return false
  end
  
  def recents
    return @recents if @recents
    @recents = RecentEntityType.find(:all).map(&:entity_type).map do |entity_type|
      entity_type.entity_class.recents_to(self)
    end.flatten.sort
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
    non_admin.find(:all,
                   :conditions => ["lower(display_name) like :search_text or " <<
                                   "lower(first_name) like :search_text or " <<
                                   "lower(last_name) like :search_text",
                                   {:search_text => "%#{search_text.downcase}%"}],
                   :order => "last_name, first_name, display_name")
  end
  
  def previous_login_at=(time)
    user_activity.update_attribute :previous_login_at, time
  end
  
  private
  
  def hash(str)
    Digest::SHA1.hexdigest(str)
  end
  
end
