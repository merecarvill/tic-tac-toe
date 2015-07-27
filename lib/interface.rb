require_relative 'command_line_interface'

module TicTacToe
  class Interface
    InterfaceError = Class.new(StandardError)

    def initialize(type)
      case type
      when :command_line
        @interface = TicTacToe::CommandLineInterface.new
      end
    end

    def game_setup_interaction(player_marks)
      if @interface.respond_to?(:game_setup_interaction)
        @interface.game_setup_interaction(player_marks)
      else
        raise InterfaceError, "#{self.class}#game_setup_interaction is not implemented"
      end
    end

    def show_game_board(board)
      if @interface.respond_to?(:show_game_board)
        @interface.show_game_board(board)
      else
        raise InterfaceError, "#{self.class}#show_game_board is not implemented"
      end
    end

    def solicit_move(player_mark)
      if @interface.respond_to?(:solicit_move)
        @interface.solicit_move(player_mark)
      else
        raise InterfaceError, "#{self.class}#solicit_move is not implemented"
      end
    end

    def report_invalid_move(move_coordinates, reason)
      if @interface.respond_to?(:report_invalid_move)
        @interface.report_invalid_move(move_coordinates, reason)
      else
        raise InterfaceError, "#{self.class}#report_invalid_move is not implemented"
      end
    end

    def report_move(player_mark, move_coordinates)
      if @interface.respond_to?(:report_move)
        @interface.report_move(player_mark, move_coordinates)
      else
        raise InterfaceError, "#{self.class}#report_move is not implemented"
      end
    end

    def report_win(player_mark)
      if @interface.respond_to?(:report_win)
        @interface.report_move(player_mark)
      else
        raise InterfaceError, "#{self.class}#report_win is not implemented"
      end
    end
  end
end