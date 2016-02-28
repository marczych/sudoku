require 'Set'

module Sudoku
   class Board
      VALID_STATE_REGEX = /[.0-9]{81}/

      def initialize(state)
         @board = Array.new

         if !state.match(VALID_STATE_REGEX)
            raise ArgumentError.new('State must be exactly 81 non-whitespace characters.')
         end

         state.each_char do |char|
            if char == '.'
               @board << Set.new(1..9)
            else
               @board << char.to_i
            end
         end
      end

      def get_state
         state = ''

         @board.each do |cell|
            if cell.is_a?(Integer)
               state << cell.to_s
            else
               state << '.'
            end
         end

         return state
      end

      def solved?
         return @board.all? do |cell|
            cell.is_a?(Integer)
         end
      end

      def solve
         return true
      end
   end
end
