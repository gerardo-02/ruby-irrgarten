# frozen_string_literal: true

require_relative 'dice'
require_relative 'game_state'
require_relative 'player'
require_relative 'monster'
require_relative 'labyrinth'
require_relative 'orientation'
require_relative 'directions'
require_relative 'game_character'
require_relative 'fuzzy_player'

module Irrgarten
  class Game
    @@MAX_ROUNDS = 10

    public
    def initialize(nplayers)
      @players = Array.new
      @monsters = Array.new

      for i in 0..nplayers-1 do
        @players.push(Player.new(i.to_s, Dice.random_intelligence, Dice.random_strength))
      end

      @labyrinth = Labyrinth.new(10, 10, 9, 9)
      @currentPlayerIndex = Dice.who_starts(nplayers)
      @currentPlayer = @players[@currentPlayerIndex]
      @log = String.new

      configure_labyrinth
      @labyrinth.spread_players(@players)
    end

    def finished
      return @labyrinth.have_a_winner
    end

    def next_step(preferredDirection)
      @log.clear
      if !@currentPlayer.dead
        direction = actual_direction(preferredDirection)

        if direction != preferredDirection
          log_player_no_orders
        end

        monster = @labyrinth.put_player(direction, @currentPlayer)

        if monster == nil
          log_no_monster
        else
          winner = combat(monster)
          manage_reward(winner)
        end

      else
        manage_resurrection
      end

      endGame = finished
      if !endGame
        next_player
      end
      return endGame
    end

    def game_state
      return GameState.new(@labyrinth.to_s, @players.size.to_s, @monsters.size.to_s, @current_player_index, finished, @log)
    end

    private
    def configure_labyrinth
      @labyrinth.add_block(Orientation::HORIZONTAL, 2, 0, 3)
      @labyrinth.add_block(Orientation::VERTICAL, 9, 5, 4)
      @labyrinth.add_block(Orientation::HORIZONTAL, 7, 9, 2)
      @labyrinth.add_block(Orientation::HORIZONTAL, 6, 0, 2)
      @labyrinth.add_block(Orientation::VERTICAL, 0, 7, 5)

      for i in 0..3 do
        monster = Monster.new("Monster ##{i.to_c}", Dice.random_intelligence, Dice.random_strength)
        @labyrinth.add_monster(Dice.random_pos(10), Dice.random_pos(10), monster)
        @monsters.push(monster)
      end
    end

    def next_player
      @currentPlayerIndex = (@currentPlayerIndex + 1) % @players.size
      @currentPlayer = @players[@currentPlayerIndex]
    end

    def actual_direction(preferredDirection)
      currentRow = @currentPlayer.row
      currentCol = @currentPlayer.col

      validMoves = @labyrinth.validMoves(currentRow, currentCol)
      return @currentPlayer.move(preferredDirection, validMoves)
    end

    def combat(monster)
      rounds = 0
      winner = GameCharacter::PLAYER
      playerAttack = @currentPlayer.attack
      lose = monster.defend(playerAttack)
      while !lose && rounds < @@MAX_ROUNDS do
        winner = GameCharacter::MONSTER
        rounds += 1
        monsterAttack = monster.attack
        lose = @currentPlayer.defend(monsterAttack)
        if !lose
          winner = GameCharacter::PLAYER
          playerAttack = @currentPlayer.attack
          lose = monster.defend(playerAttack)
        end
      end
      log_rounds(rounds, @@MAX_ROUNDS)
      return winner
    end

    def manage_reward(winner)
      if winner == GameCharacter::PLAYER
        @currentPlayer.receive_reward
        log_player_won
      else
        log_monster_won
      end
    end

    def manage_resurrection
      if Dice.resurrect_player
        @currentPlayer.resurrect
        @currentPlayer = FuzzyPlayer.new
        log_resurrected
      else
        log_player_skip_turn
      end
    end

    def log_player_won
      @log += "Player has won the combat.\n"
    end

    def log_monster_won
      @log += "Monster has won the combat.\n"
    end

    def log_resurrected
      @log += "Player has resurrected.\n"
    end

    def log_player_skip_turn
      @log += "Player is dead and skips the turn.\n"
    end

    def log_player_no_orders
      @log += "Player was not able to follow the orders.\n"
    end

    def log_no_monster
      @log += "Player is on an empty square.\n"
    end

    def log_rounds(rounds, max)
      @log += "Combat is on round #{rounds} out of #{max}.\n"
    end
  end
end
