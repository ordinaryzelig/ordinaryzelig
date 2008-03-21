class PrivacyLevelType < ActiveRecord::Base
  
  TYPES = {:nobody => 1,
           :friends => 2,
           :anybody => 3}
  
  validates_presence_of :name
  
  def self.container
    PrivacyLevelType.find(:all, :order => :id).map { |plt| [plt.name, plt.id] }
  end
  
  def to_s
    self.name
  end
  
end
