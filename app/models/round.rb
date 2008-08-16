class Round < ActiveRecord::Base
  
  named_scope :non_play_in, :conditions => ['number != ?', 0], :order => :number
  
end
