class Page < ActiveRecord::Base
  
  validates_presence_of :source, :created_at, :title
  before_validation :set_times
  
  preview_using :source
  
  def set_times
    if new_record?
      self.created_at ||= Time.now.localtime
    else
      self.last_updated_at = Time.now.localtime
    end
  end
  
end
