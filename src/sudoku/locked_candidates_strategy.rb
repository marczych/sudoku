require_relative 'strategy.rb'
require 'set'

module Sudoku
   class LockedCandidatesStrategy < Strategy
      def step(board)
         step_pointed(board)
         step_claiming_row(board)
         step_claiming_col(board)
      end

      private

      def step_pointed(board)
         board.each_box do |box_x, box_y|
            start_x = box_x * 3
            start_y = box_y * 3

            candidates = Hash.new do |hash, key|
               hash[key] = {
                  :columns => Set.new,
                  :rows => Set.new,
               }
            end

            board.box_each(box_x, box_y) do |x, y, value|
               value = board.get(x, y)

               if value.is_a?(Set)
                  value.each do |candidate|
                     candidates[candidate][:columns].add(x)
                     candidates[candidate][:rows].add(y)
                  end
               end
            end

            candidates.each do |candidate, locations|
               columns = locations[:columns]
               rows = locations[:rows]

               if columns.size == 1
                  columns.each do |column|
                     (0..8).each do |row|
                        if !row.between?(start_y, start_y + 2)
                           board.remove_candidate(column, row, candidate)
                        end
                     end
                  end
               end

               if rows.size == 1
                  rows.each do |row|
                     (0..8).each do |column|
                        if !column.between?(start_x, start_x + 2)
                           board.remove_candidate(column, row, candidate)
                        end
                     end
                  end
               end
            end
         end
      end

      def step_claiming_row(board)
         (0..8).each do |row|
            box_y = (row / 3).to_i

            candidates = Hash.new do |hash, key|
               hash[key] = Set.new
            end

            board.row_each(row) do |x, y, value|
               value = board.get(x, y)

               if value.is_a?(Set)
                  value.each do |candidate|
                     candidates[candidate].add(x)
                  end
               end
            end

            candidates.each do |candidate, columns|
               (0..2).each do |box_x|
                  start_x = box_x * 3

                  # The candidate is constrained to this box.
                  if columns.subset?(Set.new(start_x..(start_x + 2)))
                     board.box_each(box_x, box_y) do |x, y, _|
                        if y != row
                           board.remove_candidate(x, y, candidate)
                        end
                     end
                  end
               end
            end
         end
      end

      def step_claiming_col(board)
         (0..8).each do |col|
            box_x = (col / 3).to_i

            candidates = Hash.new do |hash, key|
               hash[key] = Set.new
            end

            board.col_each(col) do |x, y, value|
               value = board.get(x, y)

               if value.is_a?(Set)
                  value.each do |candidate|
                     candidates[candidate].add(y)
                  end
               end
            end

            candidates.each do |candidate, rows|
               (0..2).each do |box_y|
                  start_y = box_y * 3

                  # The candidate is constrained to this box.
                  if rows.subset?(Set.new(start_y..(start_y + 2)))
                     board.box_each(box_x, box_y) do |x, y, _|
                        if x != col
                           board.remove_candidate(x, y, candidate)
                        end
                     end
                  end
               end
            end
         end
      end
   end
end
