# frozen_string_literal: true

require_relative 'dice'
require_relative 'combat_element'

module Irrgarten

  class Shield < CombatElement

    public_class_method :new

    def protect
      return produce_effect
    end

    def to_s
      out = "S" + super
      out
    end

  end

end
