require_relative 'strategy.rb'
require 'set'

module Sudoku
   class LockedCandidatesStrategy < Strategy
      def step(board)
         step_pointed(board)
      end

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
   end
end
