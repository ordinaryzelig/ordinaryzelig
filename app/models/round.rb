class Round < ActiveRecord::Base
  
  scope_out :non_play_in, :conditions => ['number != ?', 0], :order => :number
  
end
