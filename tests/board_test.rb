require 'test/unit'
require_relative '../board.rb'

class BoardTest < Test::Unit::TestCase
   def test_get_state
      state = "..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4.."
      assert(state, Board.new(state).get_state);
   end
end
