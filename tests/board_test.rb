require 'test/unit'
require_relative '../src/sudoku/board.rb'

class BoardTest < Test::Unit::TestCase
   def test_invalid_state
      assert_invalid_state = proc do |state|
         assert_raise Sudoku::Error do
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

      assert_valid_state.call('1..2..3...................................................................1..2..3')
      assert_invalid_state.call('1..2..3.........................................2.........................1..2..3')
   end

   def test_initialize
      expected_set = Set.new(2..9)
      board = Sudoku::Board.new('........................................1........................................')

      assert_equal(Set.new(1..9), board.get(0, 0))
      assert_equal(expected_set, board.get(3, 3))

      (0..8).each do |i|
         if i != 4
            assert_equal(expected_set, board.get(4, i))
            assert_equal(expected_set, board.get(i, 4))
         end
      end
   end

   def test_get_state
      state = "..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4.."
      assert_equal(state, Sudoku::Board.new(state).get_state());
   end

   def test_get_pretty_state
      board = Sudoku::Board.new('........................................1........................................')
      expected = <<STATE
.........
.........
.........
.........
....1....
.........
.........
.........
.........
STATE

      assert_equal(expected, board.get_pretty_state)
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
         assert_raise Sudoku::Error do
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

   def test_remove_candidate
      board = Sudoku::Board.new("..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4..")

      assert_equal(Set, board.get(0, 0).class)
      assert_equal(5, board.get(0, 0).length)
      board.remove_candidate(0, 0, 5)

      candidates = board.get(0, 0)
      assert_equal(4, board.get(0, 0).length)
      assert_false(candidates.include?(5))

      assert_invalid_remove_candidate = proc do |x, y, candidate|
         assert_raise Sudoku::Error do
            board.remove_candidate(x, y, candidate)
         end
      end

      # Already not a viable candidate.
      assert_invalid_remove_candidate.call(0, 0, 5)

      # Already solved.
      assert_invalid_remove_candidate.call(2, 0, 3)

      # Invalid argument.
      assert_invalid_remove_candidate.call(0, 0, 10)

      # Invalid argument.
      assert_invalid_remove_candidate.call(0, 0, 0)

      # Invalid argument.
      assert_invalid_remove_candidate.call(0, 0, "I'm a string!")
   end

   def test_solve
      board = Sudoku::Board.new("..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4..")

      assert(board.get(0, 1).include?(5))
      assert(board.get(1, 1).include?(5))

      board.solve(0, 0, 5)
      assert_equal(5, board.get(0, 0))
      assert_false(board.get(0, 1).include?(5))
      assert_false(board.get(1, 1).include?(5))
   end

   def test_invalid_solve
      board = Sudoku::Board.new("..2.3...8.....8....31.2.....6..5.27..1.....5.2.4.6..31....8.6.5.......13..531.4..")
      assert_invalid_solve = proc do |x, y, value|
         assert_raise Sudoku::Error do
            board.solve(x, y, value)
         end
      end

      # Conflicts with the 2 right next to it.
      assert_invalid_solve.call(0, 0, 2)

      # Conflicts with the 3 in the same block.
      assert_invalid_solve.call(0, 0, 3)

      # Conflicts with the 2 right next to it.
      assert_invalid_solve.call(0, 0, 2)

      # Already solved.
      assert_invalid_solve.call(2, 0, 1)

      assert_invalid_solve.call(0, 0, "I'm a string!")
   end

   def test_each
      board = Sudoku::Board.new('........................................1........................................')

      board.each do |x, y, value|
         if x == 4 and y == 4
            assert_equal(1, value)
         elsif x == 4 or y == 4 or (x.between?(3, 5) and y.between?(3, 5))
            assert_equal(Set.new(2..9), value)
         else
            assert_equal(Set.new(1..9), value)
         end
      end
   end

   def test_col_row_each
      board = Sudoku::Board.new('........................................1........................................')

      board.row_each(4) do |x, y, value|
         if x == 4
            assert_equal(1, value)
         else
            assert_equal(Set.new(2..9), value)
         end
      end

      board.col_each(4) do |x, y, value|
         if y == 4
            assert_equal(1, value)
         else
            assert_equal(Set.new(2..9), value)
         end
      end

      board.col_each(0) do |x, y, value|
         if y == 4
            assert_equal(Set.new(2..9), value)
         else
            assert_equal(Set.new(1..9), value)
         end
      end
   end

   def test_each_box
      board = Sudoku::Board.new('.' * 81)
      values = []

      board.each_box do |box_x, box_y|
         values << {
            :box_x => box_x,
            :box_y => box_y
         }
      end

      assert_equal([
         {:box_x => 0, :box_y => 0},
         {:box_x => 0, :box_y => 1},
         {:box_x => 0, :box_y => 2},
         {:box_x => 1, :box_y => 0},
         {:box_x => 1, :box_y => 1},
         {:box_x => 1, :box_y => 2},
         {:box_x => 2, :box_y => 0},
         {:box_x => 2, :box_y => 1},
         {:box_x => 2, :box_y => 2},
      ], values)
   end

   def test_box_each
      board = Sudoku::Board.new("973648521528719634641523879864397215392851746157264983485932167236175498719486352")
      expected = [
         [9, 5, 6],
         [7, 2, 4],
         [3, 8, 1],
      ]

      board.box_each(0, 0) do |x, y, value|
         assert_equal(expected[x][y], value)
      end
   end

   def test_get_num_changes
      board = Sudoku::Board.new('.................................................................................')

      initial_changes = board.get_num_changes

      board.solve(0, 0, 1)

      assert(board.get_num_changes > initial_changes)
   end
end
