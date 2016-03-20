require 'test/unit'
require_relative '../src/sudoku/board.rb'

class StrategyTestBase < Test::Unit::TestCase
   def get_strategy
      raise NotImplementedError.new("get_strategy not implemented for #{self.class}")
   end

   def assert_step_change(initial, expected)
      board = Sudoku::Board.new(initial)
      strategy = get_strategy()

      strategy.step(board)

      assert_equal(expected, board.get_state())
   end
end
