class Page < ActiveRecord::Base
  
  validates_presence_of :source, :title
  
  before_update do |page|
    page.last_updated_at = Time.now.localtime
  end
  
  preview_using :source
  
end
