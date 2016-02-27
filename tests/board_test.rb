require 'test/unit'
require_relative '../src/sudoku/board.rb'

class BoardTest < Test::Unit::TestCase
   def test_invalid_state
      assert_invalid_state = proc do |state|
         assert_raise ArgumentError do
            Sudoku::Board.new(state)
         end
      end

      assert_valid_state = proc do |state|
         assert_nothing_raised do
            Sudoku::Board.new(state)
         end
      end

      assert_invalid_state.call('asdf')
      assert_valid_state.call('.................................................................................')
      assert_invalid_state.call('................................................................................ ')
      assert_invalid_state.call('.......................................................B.........................')
   end

   def test_get_state
      state = "..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4.."
      assert_equal(state, Sudoku::Board.new(state).get_state());
   end

   def test_hidden_singles_puzzle
      assert_puzzle('hidden_singles')
   end

   def test_last_empty_square_puzzle
      assert_puzzle('last_empty_square')
   end

   def test_naked_singles_puzzle
      assert_puzzle('naked_singles')
   end

   def test_one_puzzle
      assert_puzzle('one')
   end

   def test_solved_puzzle
      assert_puzzle('solved')
   end

   def assert_puzzle(puzzle_name)
      puzzle_file = "tests/puzzles/#{puzzle_name}.puz"
      solution_file = "tests/puzzles/#{puzzle_name}.sol"
      board = Sudoku::Board.new(File.read(puzzle_file).strip)

      assert(board.solve())
      assert_equal(File.read(solution_file).strip, board.get_state)
   end
end
