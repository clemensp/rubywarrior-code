class Player
  attr_reader :hp

  def play_turn(warrior)
    @warrior = warrior
    check_archer_presence
    if warrior.feel.empty?
      if warrior.health > 18
        warrior.walk!
      else
        if has_archer_present?
          warrior.walk!
        else
          warrior.rest!
        end
      end
    elsif warrior.feel.captive?
      warrior.rescue!
    else
      if warrior.health > 10
        warrior.attack!
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
    if @warrior.feel.empty?
      @archer_present = hp_dropped_since_last_turn?
    end
  end

  def hp_dropped_since_last_turn?
    return false if hp.nil?
    @warrior.health < hp
  end
end
