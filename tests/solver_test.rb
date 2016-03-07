require 'test/unit'
require_relative '../src/sudoku/solver.rb'
require_relative '../src/sudoku/singles_strategy.rb'
require_relative '../src/sudoku/hidden_singles_strategy.rb'

class SolverTest < Test::Unit::TestCase
   def test_hidden_singles_puzzle
      assert_puzzle('hidden_singles')
   end

   def test_last_empty_square_puzzle
      assert_puzzle('last_empty_square')
   end

   def test_naked_singles_puzzle
      assert_puzzle('naked_singles')
   end

   def test_solved_puzzle
      assert_puzzle('solved')
   end

   def assert_puzzle(puzzle_name)
      puzzle_file = "tests/puzzles/#{puzzle_name}.puz"
      solution_file = "tests/puzzles/#{puzzle_name}.sol"
      solver = Sudoku::Solver.new(File.read(puzzle_file).strip, [
         Sudoku::SinglesStrategy.new,
         Sudoku::HiddenSinglesStrategy.new
      ])


      assert(solver.solve())
      assert_equal(File.read(solution_file).strip, solver.get_state)
   end
end
