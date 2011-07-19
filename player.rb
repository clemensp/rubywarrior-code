class Player
  attr_reader :hp

  def play_turn(warrior)
    if warrior.feel.empty?
      if warrior.health > 18
        warrior.walk!
      else
        if hp_dropped_since_last_turn? warrior
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

  private
  def hp_dropped_since_last_turn? warrior
    return false if hp.nil?
    warrior.health < hp
  end
end
