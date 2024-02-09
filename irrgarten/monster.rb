# frozen_string_literal: true
require_relative 'dice'
require_relative 'labyrinth_character'

module Irrgarten
  class Monster < LabyrinthCharacter

    public_class_method :new

    @@INITIAL_HEALTH = 10

    def initialize(name, intelligence, strength)
      super(name, intelligence, strength, @@INITIAL_HEALTH)
    end

    def attack
      return Dice.intensity(@strength)
    end

    def defend(receivedAttack)
      if !dead
        if Dice.intensity(@intelligence) < receivedAttack
          got_wounded
        end
      end

      return dead
    end

  end
end

