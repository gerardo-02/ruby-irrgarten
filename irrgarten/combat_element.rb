# frozen_string_literal: true

module Irrgarten

  class CombatElement

    def initialize(effect, uses)
      @effect = effect
      @uses = uses
    end

    def discard
      return Dice.discard_element(@uses)
    end

    def to_s
      out = "[#{@effect},#{@uses}]"
      out
    end

    protected
    def produce_effect
      if @uses > 0
        @uses -= 1
        return @effect
      else
        return 0
      end
    end

    private_class_method :new

  end

end
