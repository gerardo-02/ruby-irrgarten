# frozen_string_literal: true
require_relative 'dice'
require_relative 'player'
require_relative 'directions'

module Irrgarten

  class FuzzyPlayer < Player

    def copy(other)
      super(other)
    end

    def move(direction, validMoves)
      return Dice.next_step(super(direction, validMoves), validMoves, @intelligence)
    end

    def attack
      return Dice.intensity(strength) + sum_weapons
    end

    def to_s
      out = "Fuzzy" + super
      out
    end

    protected
    def defensive_energy
      return Dice.intensity(intelligence) + sum_shields
    end
  end

end
