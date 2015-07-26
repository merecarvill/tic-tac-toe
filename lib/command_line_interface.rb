module TicTacToe
  class CommandLineInterface
    CommandLineInterfaceError = Class.new(StandardError)

    def set_up_game(player_marks)
      puts instructions
      player_marks.each_with_object([]) do |mark, player_types|
        player_types << solicit_player_type(mark)
      end
    end

    def solicit_player_type(player_mark)
      puts "Is player #{player_mark} a human or computer?"
      puts "Enter 'computer' or 'human'."
      begin
        get_valid_input([:computer, :human])
      rescue CommandLineInterfaceError => msg
        puts "Sorry, #{msg}. Please try again."
        retry
      end
    end

    def get_valid_input(valid_inputs)
      tokenized_input = gets.strip.downcase.to_sym
      if valid_inputs.include?(tokenized_input)
        tokenized_input
      else
        raise CommandLineInterfaceError, "'#{tokenized_input}' input is invalid"
      end
    end

    def instructions
      <<-EOS
~*~ Welcome to TIC TAC TOE ~*~
TODO: Instructions
EOS
    end
  end
end