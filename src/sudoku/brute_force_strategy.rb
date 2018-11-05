require_relative 'strategy.rb'

module Sudoku
   class BruteForceStrategy < Strategy
      def step(board)
         if board.solved?
            return
         end

         x, y = get_fewest_options_candidate(board)
         value = board.get(x, y)

         value.each do |candidate|
            # Clone the board and take a guess at the solution.
            guess_board = board.clone
            guess_board.solve(x, y, candidate)

            # Recurse and continue guessing. This needs to happen before
            # checking if the board is solved otherwise the solution doesn't go
            # up the call stack.
            step(guess_board)

            # If it's solved, update the real board.
            if guess_board.solved?
               guess_board.each do |solved_x, solved_y, solved_value|
                  if board.get(solved_x, solved_y).is_a?(Set)
                     board.solve(solved_x, solved_y, solved_value)
                  end
               end

               # Don't continue guessing if we've solved it!
               return
            end
         end
      end

      private

      # Returns an (x, y) tuple of the unsolved cell with the fewest candidates.
      def get_fewest_options_candidate(board)
         fewest_x = nil
         fewest_y = nil
         fewest_count = 9

         board.each do |x, y, value|
            if value.is_a?(Set) and value.size < fewest_count
               fewest_x = x
               fewest_y = y
               fewest_count = value.size
            end
         end

         return fewest_x, fewest_y
      end
   end
end
