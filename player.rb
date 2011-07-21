class Player
  attr_reader :hp, :direction

  def play_turn(warrior)
    @warrior = warrior
    set_warrior_direction
    check_archer_presence_around_warrior
    take_warrior_action
    remember_warrior_hp
  end

  def take_warrior_action
    if @warrior.feel(@direction).enemy?
      handle_enemy
    elsif @warrior.feel(@direction).captive?
      handle_captive
    else
      handle_empty_space
    end
  end

  def handle_empty_space
    if @warrior.health > 18
      @warrior.walk!(@direction)
    else
      if has_archer_present?
        @warrior.walk!(@direction)
      else
        @warrior.rest!
      end
    end
  end

  def handle_captive
    @warrior.rescue!(@direction)
  end

  def handle_enemy
    if @warrior.health > 10 || has_archer_present?
      if @direction == :backward
        pivot_forward
      else
        @warrior.attack!(@direction)
      end
    else
      @warrior.walk! :backward
    end
  end

  def has_archer_present?
    @archer_present
  end

  private
  def set_warrior_direction
    @direction ||= :backward
    @direction = :forward if @warrior.feel(@direction).wall?
  end

  def pivot_forward
    @warrior.pivot!
    @direction = :forward
  end
  
  def check_archer_presence_around_warrior
    if @warrior.feel(@direction).empty?
      @archer_present = hp_dropped_since_last_turn?
    end
  end

  def hp_dropped_since_last_turn?
    return false if hp.nil?
    @warrior.health < hp
  end

  def remember_warrior_hp
    @hp = @warrior.health
  end
end
