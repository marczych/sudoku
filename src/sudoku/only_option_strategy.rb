require_relative 'strategy.rb'

module Sudoku
   class OnlyOptionStrategy < Strategy
      def step(board)
         board.each do |x, y, value|
            if value.is_a?(Set) and value.length == 1
               # There is only one option so solve the cell.
               value.each do |solution|
                  board.solve(x, y, solution)
               end
            end
         end
      end
   end
end
