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

   def test_claiming_row
      board = Sudoku::Board.new('2345678..........................................................................')

      assert(board.get(6, 1).include?(1))

      get_strategy().step(board)

      assert_equal(8, board.get(6, 0))
      assert_equal(Set.new(2..7), board.get(6, 1))
      assert_equal(Set.new(2..7), board.get(6, 2))

      assert_equal(Set.new([1, 9]), board.get(7, 0))
      assert_equal(Set.new(2..7), board.get(7, 1))
      assert_equal(Set.new(2..7), board.get(7, 2))

      assert_equal(Set.new([1, 9]), board.get(8, 0))
      assert_equal(Set.new(2..7), board.get(8, 1))
      assert_equal(Set.new(2..7), board.get(8, 2))
   end

   def test_claiming_col
      board = Sudoku::Board.new('2........3........4........5........6........7........8..........................')

      assert(board.get(1, 6).include?(1))

      get_strategy().step(board)

      assert_equal(8, board.get(0, 6))
      assert_equal(Set.new([1, 9]), board.get(0, 7))
      assert_equal(Set.new([1, 9]), board.get(0, 8))

      assert_equal(Set.new(2..7), board.get(1, 6))
      assert_equal(Set.new(2..7), board.get(1, 7))
      assert_equal(Set.new(2..7), board.get(1, 8))

      assert_equal(Set.new(2..7), board.get(2, 6))
      assert_equal(Set.new(2..7), board.get(2, 7))
      assert_equal(Set.new(2..7), board.get(2, 8))
   end
end
