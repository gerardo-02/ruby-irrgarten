# frozen_string_literal: true

module Irrgarten

  class LabyrinthCharacter

    attr_reader :row
    attr_reader :col

    def initialize(name, intelligence, strength, health)
      @name = name
      @intelligence = intelligence
      @strength = strength
      @health = health
      @row = -1
      @col = -1
    end

    def copy(other)
      @name = "Player "
      @intelligence = other.intelligence
      @strength = other.strength
      @health = other.strength
      @row = other.row
      @col = other.col
    end

    def dead
      return @health <= 0.0
    end

    def set_pos(row, col)
      @row = row
      @col = col
    end

    def to_s
      out = "[#{@name}, I: #{@intelligence}, S: #{@strength}, H: #{@health}, R: #{@row}, C: #{@col}]"
      out
    end

    protected
    def intelligence
      return @intelligence
    end

    def strength
      return @strength
    end

    def health
      return @health
    end

    def health(health)
      @health = health
    end

    def got_wounded
      @health -= 1.0
    end

    private_class_method :new

  end

end
