module TicTacToe
  class CommandLineInterface
    CommandLineInterfaceError = Class.new(StandardError)

    def game_setup_interaction(player_marks)
      puts instructions
      player_marks.map { |mark| solicit_player_type(mark) }
    end

    def solicit_player_type(player_mark)
      puts "Is player #{player_mark} a human or computer?"
      puts "Enter 'computer' or 'human'."
      begin
        get_valid_input(/^(computer|human)$/).to_sym
      rescue CommandLineInterfaceError => msg
        puts "Sorry, #{msg}. Please try again."
        retry
      end
    end

    def show_game_board(board)
      print board.to_s
    end

    def solicit_move(player_mark)
      puts "Player #{player_mark}: select your move."
      puts "Enter your move coordinates in the format 'row, col' - eg. '0, 0'."
      begin
        get_valid_input(/^\s*\d+\s*,\s*\d+\s*$/).split(',').map(&:to_i)
      rescue CommandLineInterfaceError => msg
        puts "Sorry, #{msg}. Please try again."
        retry
      end
    end

    def get_valid_input(valid_input_pattern)
      cleaned_input = gets.strip.downcase
      if valid_input_pattern =~ cleaned_input
        cleaned_input
      else
        fail CommandLineInterfaceError, "'#{cleaned_input}' input is invalid"
      end
    end

    def report_invalid_move(move_coordinates)
      row, col = move_coordinates
      puts "Couldn't move at row: #{row}, column: #{col}. Please try again."
    end

    def report_move(player_mark, move_coordinates)
      row, col = move_coordinates
      puts "Player #{player_mark} moved at row: #{row}, column: #{col}."
    end

    def report_game_over(winning_player)
      if winning_player == :none
        report_draw
      else
        report_win(winning_player)
      end
    end

    def report_win(player_mark)
      puts "Player #{player_mark} wins!"
    end

    def report_draw
      puts 'The game ended in a draw.'
    end

    def instructions
      <<-EOS
~*~ Welcome to TIC TAC TOE ~*~
You've probably done this a million times before.
You don't need me to tell you what to do.
Go get 'em killer~
EOS
    end
  end
end
