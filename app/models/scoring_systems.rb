module ScoringSystems
  
  def self.default
    Jared
  end
  
  def self.container
    SYSTEMS.sort.map { |id, system| [system, id] }
  end
  
  module Jared
    
    # seed * round.
    def self.point_worth(pic)
      if pic.bid
        pic.bid.seed * pic.game.round.number
      else
        0
      end
    end
    
    def self.id
      1
    end
    
    def self.to_s
      "seed x round"
    end
    
  end
  
  module Cbs
    
    # (round - 1) ^ 2
    def self.point_worth(pic)
      if pic.bid
        2 ** (pic.game.round.number)
      else
        0
      end
    end
    
    def self.id
      2
    end
    
    def self.to_s
      "cbs sportsline bracket challenge"
    end
    
  end
  
  module Espn
    
    def self.point_worth(pic)
      if pic.bid
        case pic.game.round.number
        when 1
          10
        when 2
          20
        when 3
          40
        when 4
          80
        when 5
          120
        when 6
          160
        end
      else
        0
      end
    end
    
    def self.id
      3
    end
    
    def self.to_s
      "espn tournament challenge"
    end
    
  end
  
  module SportsIllustrated
    
    def self.point_worth(pic)
      point_worth = 0
      if pic.bid
        case pic.game.round.number
        when 1
          point_worth = 1
        when 2
          point_worth = 2
        when 3
          point_worth = 3
        when 4
          point_worth = 4
        when 5
          point_worth = 16
        when 6
          point_worth = 32
        end
      end
      point_worth *= 2 if pic.is_upset? && pic.game.round.number <= 4
      point_worth
    end
    
    def self.id
      4
    end
    
    def self.to_s
      "sports illustrated"
    end
    
  end
  
  SYSTEMS = {Jared.id => Jared,
             Espn.id => Espn,
             Cbs.id => Cbs,
             SportsIllustrated.id => SportsIllustrated}
  SYSTEMS.default = self.default
  SYSTEMS.freeze
  
end
