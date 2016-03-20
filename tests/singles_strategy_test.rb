require_relative 'strategy_test_base.rb'
require_relative '../src/sudoku/singles_strategy.rb'

class SinglesStrategyTest < StrategyTestBase
   def get_strategy
      return Sudoku::SinglesStrategy.new
   end

   def test_row
      assert_step_change(
         '12345678.........................................................................',
         '123456789........................................................................',
      )
   end

   def test_column
      assert_step_change(
         '1........2........3........4........5........6........7........8.................',
         '1........2........3........4........5........6........7........8........9........',
      )
   end

   def test_box
      assert_step_change(
         '123......456......78.............................................................',
         '123......456......789............................................................',
      )
   end
end
