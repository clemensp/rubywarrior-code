class Player
  attr_reader :hp, :direction

  def play_turn(warrior)
    @warrior = warrior

    check_direction
    check_archer_presence

    if warrior.feel(@direction).empty?
      if warrior.health > 18
        warrior.walk!(@direction)
      else
        if has_archer_present?
          warrior.walk!(@direction)
        else
          warrior.rest!
        end
      end
    elsif warrior.feel(@direction).captive?
      warrior.rescue!(@direction)
    else
      if warrior.health > 10 || has_archer_present?
        warrior.attack!(@direction)
      else
        warrior.walk! :backward
      end
    end
    @hp = warrior.health
  end

  def has_archer_present?
    @archer_present
  end

  private
  def check_archer_presence
    if @warrior.feel(@direction).empty?
      @archer_present = hp_dropped_since_last_turn?
    end
  end

  def hp_dropped_since_last_turn?
    return false if hp.nil?
    @warrior.health < hp
  end

  def check_direction
    @direction ||= :backward
    @direction = :forward if @warrior.feel(@direction).wall?
  end
end
