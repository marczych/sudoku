require_relative 'strategy_test_base.rb'
require_relative '../src/sudoku/locked_candidates_strategy.rb'

class LoggedCandidatesPointingStrategyTest < StrategyTestBase
   def get_strategy
      return Sudoku::LockedCandidatesStrategy.new
   end

   def test_pointing_row
      board = Sudoku::Board.new('.................................................1................2.6......345...')
      affected_columns = [0, 1, 2, 6, 7, 8]

      affected_columns.each do |col|
         assert_equal(Set.new(1..9), board.get(col, 6))
      end

      get_strategy().step(board)

      affected_columns.each do |col|
         assert_equal(Set.new(2..9), board.get(col, 6))
      end

      assert_equal(Set.new([1, 7, 8, 9]), board.get(3, 6))
      assert_equal(Set.new([7, 8, 9]), board.get(4, 6))
      assert_equal(Set.new([1, 7, 8, 9]), board.get(5, 6))
   end

   def test_pointing_col
      board = Sudoku::Board.new('...........................32.......4..1.....56..................................')
      affected_rows = [0, 1, 2, 6, 7, 8]

      affected_rows.each do |row|
         assert_equal(Set.new(1..9), board.get(2, row))
      end

      get_strategy().step(board)

      affected_rows.each do |row|
         assert_equal(Set.new(2..9), board.get(2, row))
      end

      assert_equal(Set.new([1, 7, 8, 9]), board.get(2, 3))
      assert_equal(Set.new([7, 8, 9]), board.get(2, 4))
      assert_equal(Set.new([1, 7, 8, 9]), board.get(2, 5))
   end
end
