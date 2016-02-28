require_relative 'board.rb'

module Sudoku
   class Solver
      def initialize(state)
         @board = Board.new(state)
         @strategies = []
      end

      def solve
         return true
      end

      def get_state
         return @board.get_state
      end
   end
end
