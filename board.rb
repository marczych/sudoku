require 'Set'

class Board
   def initialize(state)
      @board = Array.new

      if state.length != 9 ** 2
         raise ArgumentError.new('State must be exactly 81 characters.')
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

   def solve
      return true
   end
end
