module TicTacToe
  class CommandLineInterface

    def initialize(parameters)
      @input = parameters[:input]
      @output = parameters[:output]
    end

    def game_setup_interaction(player_marks)
      @output.puts instructions
      player_marks.map { |mark| solicit_player_type(mark) }
    end

    def solicit_player_type(player_mark)
      @output.puts "Is player #{player_mark} a human or computer?"
      @output.puts "Enter 'computer' or 'human'."

      cleaned_input = get_valid_input(/^(computer|human)$/)
      cleaned_input.to_sym
    end

    def show_game_board(board)
      row_separator = "----" * board.size + "-\n"
      col_separator = "|"

      @output.print assemble_board_string(board, row_separator, col_separator)
    end

    def solicit_move(player_mark)
      @output.puts "Player #{player_mark}: select your move."
      @output.puts "Enter your move coordinates in the format 'row, col' - eg. '0, 0'."

      cleaned_input = get_valid_input(/^\s*\d+\s*,\s*\d+\s*$/)
      cleaned_input.split(",").map(&:to_i)
    end

    def get_valid_input(valid_input_pattern)
      catch(:success) do
        loop do
          cleaned_input = @input.gets.strip.downcase
          throw(:success, cleaned_input) if valid_input_pattern =~ cleaned_input
          @output.puts "Sorry, '#{cleaned_input}' is not valid input. Please try again."
        end
      end
    end

    def report_invalid_move(move_coordinates)
      row, col = move_coordinates
      @output.puts "Couldn't move at row: #{row}, column: #{col}. Please try again."
    end

    def report_move(player_mark, move_coordinates)
      row, col = move_coordinates
      @output.puts "Player #{player_mark} moved at row: #{row}, column: #{col}."
    end

    def report_game_over(winning_player)
      if winning_player == :none
        report_draw
      else
        report_win(winning_player)
      end
    end

    def report_win(player_mark)
      @output.puts "Player #{player_mark} wins!"
    end

    def report_draw
      @output.puts "The game ended in a draw."
    end

    def instructions
      <<-EOS
~*~ Welcome to TIC TAC TOE ~*~
You've probably done this a million times before.
You don't need me to tell you what to do.
Go get 'em killer~
EOS
    end

    private

    def assemble_board_string(board, row_separator, col_separator)
      output_string = row_separator
      (0...board.size).each do |row|
        output_string += col_separator
        (0...board.size).each do |col|
          output_string += " #{board.read_space([row, col]) || " "} " + col_separator
        end
        output_string += "\n" + row_separator
      end
      output_string
    end
  end
end
