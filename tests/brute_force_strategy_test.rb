require_relative 'strategy_test_base.rb'
require_relative '../src/sudoku/brute_force_strategy.rb'

class BruteForceStrategyTest < StrategyTestBase
   def get_strategy
      return Sudoku::BruteForceStrategy.new
   end

   def test_row
      assert_step_change(
         '36542781948793152612985637485279364161324895797..65283241389765538674192796512438',
         '365427819487931526129856374852793641613248957974165283241389765538674192796512438',
      )
   end
end
