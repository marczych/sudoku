require 'Set'

class Board
   def initialize(state)
      @board = Array.new

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
            state << cell
         else
            state << '.'
         end
      end

      return state
   end
end
