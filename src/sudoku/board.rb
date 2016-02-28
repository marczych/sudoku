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

         if !value.is_a?(Integer) or value <= 0 or value > 9
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

         if !@board[get_offset(x, y)].include?(value)
            raise ArgumentError.new('Not a viable option.')
         end

         @board[get_offset(x,  y)] = value

         remove_option_from_set = proc do |remove_x, remove_y|
            cell = @board[get_offset(remove_x, remove_y)]
            if cell.is_a?(Set)
               cell.delete(value)
            end
         end

         (0..8).each do |i|
            remove_option_from_set.call(x, i)
            remove_option_from_set.call(i, y)
         end

         start_x = (x / 3).floor
         start_y = (y / 3).floor

         (start_x..(start_x + 3)).each do |remove_x|
            (start_y..(start_y + 3)).each do |remove_y|
               remove_option_from_set.call(remove_x, remove_y)
            end
         end
      end

      private

      def get_offset(x, y)
         if x < 0 or x > 8 or y < 0 or y > 8
            raise ArgumentError.new('Invalid coordinates')
         end

         return 9 * y + x
      end
   end
end
