class Round < ActiveRecord::Base
  
  has_finder :non_play_in, :conditions => ['number != ?', 0], :order => :number
  
end
