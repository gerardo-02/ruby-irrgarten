# frozen_string_literal: true

require_relative 'dice'
require_relative 'weapon'
require_relative 'shield'
require_relative 'player'
require_relative 'monster'
require_relative 'directions'

module Irrgarten
  class Labyrinth
    @@BLOCK_CHAR = 'X'
    @@EMPTY_CHAR = '-'
    @@MONSTER_CHAR = 'M'
    @@COMBAT_CHAR = 'C'
    @@EXIT_CHAR = 'E'
    @@ROW = 0
    @@COL = 1

    public
    def initialize(nRows, nCols, exitRow, exitCol)
      @nRows = nRows
      @nCols = nCols
      @exitRow = exitRow
      @exitCol = exitCol

      @monsters = Array.new(nRows){Array.new(nCols)}
      @players = Array.new(nRows){Array.new(nCols)}
      @labyrinth = Array.new(nRows){Array.new(nCols, @@EMPTY_CHAR)}
      @labyrinth[exitRow][exitCol] = @@EXIT_CHAR
    end

    def spread_players(players)
      for i in players do
        pos = random_empty_pos
        put_player_2D(-1, -1, pos[@@ROW], pos[@@COL], i)
      end
    end

    def have_a_winner
      return @players[@exitRow][@exitCol] != nil;
    end

    def to_s
      out = "L[R: #{@nRows}, C: #{@nCols}, ER: #{@exitRow}, EC: #{@exitCol}"
      out
    end

    def add_monster(row, col, monster)
      if pos_ok(row, col) && empty_pos(row, col)
        @labyrinth[row][col] = @@MONSTER_CHAR
        monster.set_pos(row, col)
        @monsters[row][col] = monster
      end
    end

    def put_player(direction, player)
      oldRow = player.row
      oldCol = player.col
      newPos = dir_2_pos(player.row, player.col, direction)
      return put_player_2D(oldRow, oldCol, newPos[@@ROW], newPos[@@COL], player)
    end

    def add_block(orientation, startRow, startCol, length)
      if orientation == Orientation::VERTICAL
        incRow = 1
        incCol = 0
      else
        incRow = 0
        incCol = 1
      end

      while pos_ok(startRow, startCol) && empty_pos(startRow, startCol) && length > 0 do
        @labyrinth[startRow][startCol] = @@BLOCK_CHAR
        startRow += incRow
        startCol += incCol
      end
    end

    def valid_moves(row, col)
      output = Array.new

      if can_step_on(row+1, col)
        output.push(Directions::DOWN)
      end
      if can_step_on(row-1, col)
        output.push(Directions::UP)
      end
      if can_step_on(row, col+1)
        output.push(Directions::RIGHT)
      end
      if can_step_on(row, col-1)
        output.push(Directions::LEFT)
      end

      return output
    end

    def pos_ok(row, col)
      return row < @nRows && col < @nCols
    end

    def empty_pos(row, col)
      return @labyrinth[row][col] == @@EMPTY_CHAR
    end

    def monster_pos(row, col)
      return @labyrinth[row][col] == @@MONSTER_CHAR
    end

    def exit_pos(row, col)
      return @labyrinth[row][col] == @@EXIT_CHAR
    end

    def combat_pos(row, col)
      return @labyrinth[row][col] == @@COMBAT_CHAR
    end

    def can_step_on(row, col)
      return pos_ok(row, col) && (empty_pos(row, col) || monster_pos(row, col) || exit_pos(row, col))
    end

    def update_old_pos(row, col)
      if pos_ok(row, col)
        if combat_pos(row, col)
          @labyrinth[row][col] = @@MONSTER_CHAR
        else
          @labyrinth[row][col] = @@EMPTY_CHAR
        end
      end
    end

    def dir_2_pos(row, col, direction)
      pos = Array.new(2)
      pos[@@ROW] = row
      pos[@@COL] = col

      case direction
      when Directions::LEFT
        pos[@@COL] -= 1
      when Directions::RIGHT
        pos[@@COL] += 1
      when Directions::UP
        pos[@@ROW] -= 1
      when Directions::DOWN
        pos[@@ROW] += 1
      end

      return pos
    end

    def random_empty_pos
      pos = Array.new(2)
      pos[@@ROW] = Dice.random_pos(@nRows)
      pos[@@COL] = Dice.random_pos(@nCols)

      until @labyrinth[pos[@@ROW]][pos[@@COL]] == @@EMPTY_CHAR do
        pos[@@ROW] = Dice.random_pos(@nRows)
        pos[@@COL] = Dice.random_pos(@nCols)
      end

      return pos
    end

    def put_player_2D(oldRow, oldCol, row, col, player)
      output = nil
      if can_step_on(row, col)
        if pos_ok(row, col)
          if @players[oldRow][oldCol] == player
            update_old_pos(oldRow, oldCol)
            @players[oldRow][oldCol] = nil
          end
        end

        if monster_pos(row, col)
          @labyrinth[row][col] = @@COMBAT_CHAR
          output = @monsters[row][col]
        else
          number = player.number
          @labyrinth[row][col] = number
        end

        @players[row][col] = player
        player.set_pos(row, col)
      end
      return output
    end

  end
end
