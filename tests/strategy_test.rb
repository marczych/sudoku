require 'test/unit'
require_relative '../src/sudoku/strategy.rb'

class StrategyTest < Test::Unit::TestCase
   def test_required_method
      assert_raise NotImplementedError do
         NotImplementedStrategy.new.step(nil)
      end

      assert_nothing_raised do
         ImplementedStrategy.new.step(nil)
      end
   end
end

class ImplementedStrategy < Sudoku::Strategy
   def step(board)
      # Nothing.
   end
end

class NotImplementedStrategy < Sudoku::Strategy
   # Nothing.
end
