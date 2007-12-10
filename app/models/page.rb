class Page < ActiveRecord::Base
  
  validates_presence_of :source, :title
  
  preview_using :source
  
end
