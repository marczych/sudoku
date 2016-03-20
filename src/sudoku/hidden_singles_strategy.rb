require_relative 'strategy.rb'
require 'set'

module Sudoku
   class HiddenSinglesStrategy < Strategy
      def step(board)
         step_rows(board)
         step_columns(board)
         step_boxes(board)
      end

      private

      def step_rows(board)
         (0..8).each do |y|
            cells = []

            board.row_each(y) do |x, _, value|
               cells[x] = value
            end

            hidden_single = find_hidden_single(cells)

            if hidden_single
               board.solve(hidden_single[:index], y, hidden_single[:value])
            end
         end
      end

      def step_columns(board)
         (0..8).each do |x|
            cells = []

            board.col_each(x) do |_, y, value|
               cells[y] = value
            end

            hidden_single = find_hidden_single(cells)

            if hidden_single
               board.solve(x, hidden_single[:index], hidden_single[:value])
            end
         end
      end

      def step_boxes(board)
         (0..2).each do |box_x|
            (0..2).each do |box_y|
               cells = []

               (0..2).each do |x|
                  (0..2).each do |y|
                     cells[(3 * x) + y] = board.get((box_x * 3) + x, (box_y * 3) + y)
                  end
               end

               hidden_single = find_hidden_single(cells)

               if hidden_single
                  index = hidden_single[:index]
                  x_offset = (box_x * 3) + (index / 3).to_i
                  y_offset = (box_y * 3) + (index % 3)
                  board.solve(x_offset, y_offset, hidden_single[:value])
               end
            end
         end
      end

      def find_hidden_single(cells)
         possibilities = Hash.new do |hash, key|
            hash[key] = Set.new
         end

         cells.each_index do |index|
            cell = cells[index]

            if cell.is_a?(Set)
               cell.each do |value|
                  possibilities[value].add(index)
               end
            end
         end

         possibilities.each do |value, possible_cells|
            if possible_cells.length == 1
               possible_cells.each do |cell_index|
                  return {
                     :index => cell_index,
                     :value => value
                  }
               end
            end
         end

         return nil
      end
   end
end
