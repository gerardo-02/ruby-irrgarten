# frozen_string_literal: true

require_relative 'dice'
require_relative 'weapon'
require_relative 'shield'
require_relative 'game_state'
require_relative 'player'
require_relative 'monster'
require_relative 'labyrinth'
require_relative 'game'
require_relative 'directions'

module Irrgarten

  class TestP1

    def main

      monster = Monster.new("Monstro", 3, 3)
      puts monster.to_s

      player1 = Player.new('0', 4, 5)
      puts player1.to_s
      player2 = FuzzyPlayer.new(0, 0, 0)
      player2.copy(player1)
      player1.set_pos(5, 5)
      puts player1.to_s
      puts player2.to_s
      preferredDirections = [Directions::DOWN, Directions:: UP, Directions::LEFT]
      puts player1.move(Directions::LEFT, preferredDirections)

      labyrinth = Labyrinth.new(10, 10, 9, 9)

      game = Game.new(3)

    end
  end

  test = TestP1.new
  test.main

end