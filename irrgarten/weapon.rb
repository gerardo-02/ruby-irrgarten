# frozen_string_literal: true

require_relative 'dice'
require_relative 'combat_element'

module Irrgarten

  class Weapon < CombatElement

    public_class_method :new

    def attack
      return produce_effect
    end

    def to_s
      out = "W" + super
      out
    end

  end

end