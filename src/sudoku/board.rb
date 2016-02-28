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

      def get(x, y)
         return @board[get_offset(x, y)]
      end

      def remove_option(x, y, value)
         current = @board[get_offset(x, y)]

         if !value.is_a?(Integer)
            raise ArgumentError.new('Invalid value.')
         end

         if current.is_a?(Set)
            if current.include?(value)
               current.delete(value)
            else
               raise ArgumentError.new('Already not an option.')
            end
         else
            raise ArgumentError.new('Cell is already solved.')
         end
      end

      def solve(x, y, value)
         if !value.is_a?(Integer)
            raise ArgumentError.new('Can only solve with an integer.')
         end

         @board[get_offset(x,  y)] = value
      end

      private

      def get_offset(x, y)
         if x < 0 or x > 9 or y < 0 or y > 9
            raise ArgumentError.new('Invalid coordinates')
         end

         return 9 * y + x
      end
   end
end
