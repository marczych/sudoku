require_relative 'strategy_test_base.rb'
require_relative '../src/sudoku/hidden_singles_strategy.rb'

class HiddenSinglesStrategyTest < StrategyTestBase
   def get_strategy
      return Sudoku::HiddenSinglesStrategy.new
   end

   def test_row
      assert_step_change(
         '....................3456789.1....................................................',
         '..................1.3456789.1....................................................'
      )
   end

   def test_column
      assert_step_change(
         '............1.....3........4........5........6........7........8........9........',
         '1...........1.....3........4........5........6........7........8........9........',
      )
   end

   def test_box
      assert_step_change(
         '......................1.......2.5......3........4.6..............................',
         '......................1.......2.5......3.1......4.6..............................'
      )
   end
end
