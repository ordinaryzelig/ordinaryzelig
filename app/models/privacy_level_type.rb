class PrivacyLevelType < ActiveRecord::Base
  
  validates_presence_of :name
  
  def self.container
    PrivacyLevelType.find(:all, :order => :id).map { |plt| [plt.name, plt.id] }
  end
  
  def to_s
    self.name
  end
  
end
