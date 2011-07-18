class Player
  def play_turn(warrior)
    if warrior.feel.empty?
      warrior.walk!
    else
      if warrior.health > 5
        warrior.attack!
      else
        warrior.walk! :backward
      end
    end
  end
end
