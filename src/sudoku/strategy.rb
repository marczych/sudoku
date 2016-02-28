module Sudoku
   class Strategy
      # Perform another step towards solving the puzzle. Not changing anything
      # on the board indicates that this strategy cannot solve the puzzle.
      # However, leaving the puzzle unsolved doesn't indicate that this
      # strategy cannot solve the puzzle.
      def step(board)
         raise NotImplementedError.new("step not implemented for #{self.class}")
      end
   end
end
