require 'test/unit'
require_relative '../src/sudoku/board.rb'

class BoardTest < Test::Unit::TestCase
   def test_invalid_state
      assert_invalid_state = proc do |state|
         assert_raise ArgumentError do
            Sudoku::Board.new(state)
         end
      end

      assert_valid_state = proc do |state|
         assert_nothing_raised do
            Sudoku::Board.new(state)
         end
      end

      assert_invalid_state.call('asdf')
      assert_valid_state.call('.................................................................................')
      assert_invalid_state.call('................................................................................ ')
      assert_invalid_state.call('.......................................................B.........................')
   end

   def test_get_state
      state = "..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4.."
      assert_equal(state, Sudoku::Board.new(state).get_state());
   end

   def test_solved?
      assert_false(Sudoku::Board.new("..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4..").solved?)
      assert(Sudoku::Board.new("973648521528719634641523879864397215392851746157264983485932167236175498719486352").solved?)
   end

   def test_get
      board = Sudoku::Board.new("..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4..")

      assert_equal(2, board.get(2, 0))
      assert_equal(Set, board.get(0, 0).class)
      assert_equal(3, board.get(1, 2))

      assert_valid_get = proc do |x, y|
         assert_nothing_raised do
            board.get(x, y)
         end
      end

      assert_valid_get.call(0, 0)
      assert_valid_get.call(8, 0)
      assert_valid_get.call(0, 8)
      assert_valid_get.call(8, 8)
   end

   def test_invalid_get
      board = Sudoku::Board.new("..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4..")

      assert_invalid_get = proc do |x, y|
         assert_raise ArgumentError do
            board.get(x, y)
         end
      end

      assert_invalid_get.call(-1, 0)
      assert_invalid_get.call(0, -1)
      assert_invalid_get.call(-1, -1)
      assert_invalid_get.call(-9999, -9999)
      assert_invalid_get.call(9, 8)
      assert_invalid_get.call(8, 9)
      assert_invalid_get.call(9, 9)
      assert_invalid_get.call(9999, 9999)
   end

   def test_remove_option
      board = Sudoku::Board.new("..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4..")

      assert_equal(Set, board.get(0, 0).class)
      assert_equal(9, board.get(0, 0).length)
      board.remove_option(0, 0, 5)

      options = board.get(0, 0)
      assert_equal(8, board.get(0, 0).length)
      assert_false(options.include?(5))

      assert_invalid_remove_option = proc do |x, y, option|
         assert_raise ArgumentError do
            board.remove_option(x, y, option)
         end
      end

      # Already not a viable option.
      assert_invalid_remove_option.call(0, 0, 5)

      # Already solved.
      assert_invalid_remove_option.call(2, 0, 3)

      # Invalid argument.
      assert_invalid_remove_option.call(0, 0, 10)

      # Invalid argument.
      assert_invalid_remove_option.call(0, 0, 0)

      # Invalid argument.
      assert_invalid_remove_option.call(0, 0, "I'm a string!")
   end
end
