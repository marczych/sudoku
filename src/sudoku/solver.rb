require_relative 'board.rb'

module Sudoku
   class Solver
      def initialize(state, strategies)
         @board = Board.new(state)
         @strategies = strategies
      end

      def solve
         until @board.solved?
            current_changes = @board.get_num_changes

            @strategies.each do |strategy|
               strategy.step(@board)

               if @board.get_num_changes > current_changes
                  break
               end
            end

            if @board.get_num_changes <= current_changes
               return false
            end
         end

         return true
      end

      def get_state
         return @board.get_state
      end

      def get_pretty_state
         return @board.get_pretty_state
      end
   end
end
