# frozen_string_literal: true

require_relative 'dice'
require_relative 'weapon'
require_relative 'shield'
require_relative 'directions'
require_relative 'labyrinth_character'

module Irrgarten
  class Player < LabyrinthCharacter

    public_class_method :new

    @@MAX_WEAPONS = 2
    @@MAX_SHIELDS = 3
    @@INITIAL_HEALTH = 10
    @@HITS2LOSE = 3

    attr_reader :number

    def initialize(number, intelligence, strength)
      super("Player ##{number}", intelligence, strength, @@INITIAL_HEALTH)
      @number = number
      @consecutiveHits = 0
      @weapons = Array.new
      @shields = Array.new
    end

    def copy(other)
      super(other)
      @number = other.number
      @name += @number.to_s
      @consecutiveHits = 0
      @weapons = Array.new
      @shields = Array.new
    end

    def resurrect
      @weapons.clear
      @shields.clear
      @health = @@INITIAL_HEALTH
      @consecutiveHits = 0
    end

    def move(direction, validMoves)
      if validMoves.size > 0 && validMoves.index(direction) == nil
        return validMoves[0]
      else
        return direction
      end
    end

    def attack
      return @strength + sum_weapons
    end

    def defend(receivedAttack)
      return manage_hit(receivedAttack)
    end

    def receive_reward
      for i in 1..Dice.weapons_reward do
        receive_weapon(new_weapon)
      end

      for i in 1..Dice.shields_reward do
        receive_shield(new_shield)
      end

      @health += Dice.health_reward
    end

    def to_s
      out = super + " CH: #{@consecutiveHits}"
      out
    end

    private
    def receive_weapon(w)
      @weapons.delete_if {|i| i.discard}

      if @weapons.size < @@MAX_WEAPONS
        @weapons.push(w)
      end
    end

    def receive_shield(s)
      @shields.delete_if {|i| i.discard}

      if @shields.size < @@MAX_SHIELDS
        @shields.push(s)
      end
    end

    def new_weapon
      return Weapon.new(Dice.weapon_power(), Dice.uses_left())
    end

    def new_shield
      return Shield.new(Dice.shield_power(), Dice.uses_left())
    end

    protected
    def sum_weapons
      sum = 0.0
      if @weapons.size > 0
        for i in @weapons do
          sum += i.attack
        end
      end
      return sum
    end

    def sum_shields
      sum = 0.0
      if @shields.size > 0
        for i in @shields do
          sum += i.protect
        end
      end
      return sum
    end

    def defensive_energy
      return @intelligence + sum_shields
    end

    private
    def manage_hit(receivedAttack)
      if defensive_energy < receivedAttack
        got_wounded
        inc_consecutive_hits
      else
        reset_hits
      end

      if @consecutiveHits == @@HITS2LOSE || dead
        reset_hits
        return true
      else
        return false
      end
    end

    def reset_hits
      @consecutiveHits = 0
    end

    def inc_consecutive_hits
      @consecutiveHits += 1
    end
  end
end
