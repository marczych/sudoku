require 'docopt'
require_relative 'solver'
require_relative 'singles_strategy'
require_relative 'hidden_singles_strategy'

module Sudoku
   class Main
      DOC = <<-DOC
Sudoku solver.

Usage:
   #{__FILE__} <puzzle>
   #{__FILE__} -h | --help

Options:
   -h --help  Show this screen.
DOC

      def self.main
         options = nil
         begin
            options = Docopt::docopt(DOC)
         rescue Docopt::Exit => e
            puts e.message
            return 1
         end

         solver = nil

         begin
            solver = Sudoku::Solver.new(options["<puzzle>"], [
               Sudoku::SinglesStrategy.new,
               Sudoku::HiddenSinglesStrategy.new
            ])
         rescue Error => e
            puts 'Invalid puzzle.'
            return 1
         end

         begin
            solved = false

            begin
               solved = solver.solve

               if !solved
                  puts "Not solved. Partial solution:\n\n"
               end
            rescue Error => e
               puts 'Error when solving puzzle:'
               puts e
               puts "Partial solution:\n\n"
            end

            puts solver.get_pretty_state

            return solved ? 0 : 1
         end
      end
   end
end
