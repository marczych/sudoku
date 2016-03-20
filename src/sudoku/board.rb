require 'set'
require_relative 'error'

module Sudoku
   class Board
      VALID_STATE_REGEX = /[.0-9]{81}/

      def initialize(state)
         if !state.match(VALID_STATE_REGEX)
            raise Error.new('State must be exactly 81 non-whitespace characters.')
         end

         @board = Array.new(81) do
            Set.new(1..9)
         end

         @changes = 0

         (0..8).each do |x|
            (0..8).each do |y|
               char = state[get_offset(x, y)]

               if char != '.'
                  solve(x, y, char.to_i)
               end
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

      def get_pretty_state
         return self.class.prettify_state(get_state())
      end

      def self.prettify_state(state)
         return state.scan(/.{9}/).join("\n") + "\n"
      end

      def solved?
         return @board.all? do |cell|
            cell.is_a?(Integer)
         end
      end

      def get(x, y)
         return @board[get_offset(x, y)]
      end

      def get_num_changes
         return @changes
      end

      def remove_candidate(x, y, value)
         current = @board[get_offset(x, y)]

         if !value.is_a?(Integer) or value <= 0 or value > 9
            raise Error.new('Invalid value.')
         end

         if current.is_a?(Set)
            if current.include?(value)
               current.delete(value)
               @changes += 1
            else
               raise Error.new('Already not a candidate.')
            end
         else
            raise Error.new('Cell is already solved.')
         end
      end

      def solve(x, y, value)
         if !value.is_a?(Integer)
            raise Error.new('Can only solve with an integer.')
         end

         if @board[get_offset(x, y)].is_a?(Integer)
            raise Error.new('Already solved.')
         end

         if !@board[get_offset(x, y)].include?(value)
            raise Error.new('Not a viable candidate.')
         end

         @board[get_offset(x,  y)] = value
         @changes += 1

         remove_candidate_from_set = proc do |remove_x, remove_y|
            cell = @board[get_offset(remove_x, remove_y)]
            if cell.is_a?(Set)
               cell.delete(value)
            end
         end

         (0..8).each do |i|
            remove_candidate_from_set.call(x, i)
            remove_candidate_from_set.call(i, y)
         end

         start_x = (x / 3).floor * 3
         start_y = (y / 3).floor * 3

         (start_x..(start_x + 2)).each do |remove_x|
            (start_y..(start_y + 2)).each do |remove_y|
               remove_candidate_from_set.call(remove_x, remove_y)
            end
         end
      end

      # Iterators.

      def each
         (0..8).each do |x|
            (0..8).each do |y|
               yield x, y, get(x, y)
            end
         end
      end

      def row_each(y)
         (0..8).each do |x|
            yield x, y, get(x, y)
         end
      end

      def col_each(x)
         (0..8).each do |y|
            yield x, y, get(x, y)
         end
      end

      def each_box
         (0..2).each do |box_x|
            (0..2).each do |box_y|
               yield box_x, box_y
            end
         end
      end

      def box_each(box_x, box_y)
         start_x = box_x * 3
         start_y = box_y * 3

         (start_x..(start_x + 2)).each do |x|
            (start_y..(start_y + 2)).each do |y|
               yield x, y, get(x, y)
            end
         end
      end

      private

      def get_offset(x, y)
         if x < 0 or x > 8 or y < 0 or y > 8
            raise Error.new('Invalid coordinates')
         end

         return 9 * y + x
      end
   end
end
