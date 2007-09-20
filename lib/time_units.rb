module UnitOfTime

  module TimeUnit
    
    include ActionView::Helpers::TextHelper
    
    attr_accessor :unit_id
    attr_accessor :units
    attr_reader :units_up
    attr_reader :units_down
    
    def initialize(units, units_up, units_down)
      @unit_id = UNIT_CLASSES.index(self.class)
      @units = units
      @units_up = units_up
      @units_down = units_down
    end
    
    # take absolute value of units.
    # if > 1, self is acceptable but see if up is MORE practical.
    # if = 1, return self.
    # if < 1 check to see if down is a more practical unit.
    def convert_to(unit_class)
      case UNIT_CLASSES.index(unit_class) <=> unit_id
      when 0
        self
      when -1
        down.convert_to(unit_class)
      when 1
        up.convert_to(unit_class)
      end
    end
    
    alias to convert_to
    
    def to_i
      units.to_i
    end
    
    def up
      up_class.new(units.to_f / units_up.to_f) if up_class
    end
    
    def down
      down_class.new(units.to_f * units_down.to_f) if down_class
    end
    
    # subtract units of time using conversion.
    # or if unit_of_time is number, assume it's the same UnitOfTime.
    def -(unit_of_time)
      if unit_of_time.kind_of?(TimeUnit)
        self.class.new(units - unit_of_time.to(self.class).units)
      else
        self.class.new(units - unit_of_time)
      end
    end
    
    def is_negative?
      units < 0
    end
    
    # strings.
    
    def to_s
      "#{units}"
    end
    
    def pretty
      str = pluralize(to_i, Inflector.demodulize(self.class.to_s.downcase))
    end
    
    # Day.new(8).practical => in 1 week and 1 day.
    # Day.new(-8).practical => 1 week and 1 day ago.
    # Day.new(0).practical => now.
    def practical(abs = false)
      if 0 == units
        "now"
      else
        str = ""
        p_unit = to_practical
        is_negative = p_unit.is_negative?
        p_unit.units = p_unit.units.abs
        str << p_unit.pretty
        leftover = (p_unit - p_unit.to_i).to(p_unit.down_class) if p_unit.down_class
        if leftover && leftover.to_i.abs > 0
          str << " and #{leftover.pretty}"
        end
        if is_negative && !abs
          str << " ago"
        else
          str = "in #{str}"
        end
        str
      end
    end
    
    def to_practical(last_was_acceptable = false)
      case units.abs <=> 1
      when 1
        up_unit = up
        if up_unit
          up_unit.to_practical(true)
        else
          self
        end
      when 0
        self
      else
        down_unit = down
        if last_was_acceptable
          down
        else
          if down_unit
            down_unit.to_practical
          else
            self
          end
        end
      end
    end
    
    def up_class
      UNIT_CLASSES[unit_id + 1]
    end
    
    def down_class
      offset = unit_id - 1
      if offset >= 0
        UNIT_CLASSES[offset]
      end
    end
    
    private
    
  end
  
  class Second
    include TimeUnit
    def initialize(units = 0)
      super(units, 60, nil)
    end
  end
  
  class Minute
    include TimeUnit
    def initialize(units = 0)
      super(units, 60, 60)
    end
  end
  
  class Hour
    include TimeUnit
    def initialize(units = 0)
      super(units, 24, 60)
    end
  end
  
  class Day
    include TimeUnit
    def initialize(units = 0)
      super(units, 7, 24)
    end
  end
  
  class Week
    include TimeUnit
    def initialize(units = 0)
      super(units, 4.34812141, 7)
    end
  end
  
  class Month
    include TimeUnit
    def initialize(units = 0)
      super(units, 12, 4.35)
    end
  end
  
  class Year
    include TimeUnit
    def initialize(units = 0)
      super(units, nil, 12)
    end
  end
  
  UNIT_CLASSES = [Second, Minute, Hour, Day, Week, Month, Year]
  
  def time_til(time)
    Second.new(time - self).to_practical
  end
  
end

class Time
  include UnitOfTime
end
