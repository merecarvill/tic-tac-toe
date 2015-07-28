require_relative 'command_line_interface'

module TicTacToe
  class Interface
    InterfaceError = Class.new(StandardError)

    attr_reader :interface

    def self.required_methods
      [:game_setup_interaction, :show_game_board, :solicit_move,
        :report_invalid_move, :report_move, :report_game_over]
    end

    def initialize(type)
      case type
      when :command_line
        @interface = CommandLineInterface.new
      else
        raise InterfaceError, "Attempted to initialize interface with invalid type: #{type}"
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

    def report_game_over(player_mark)
      if @interface.respond_to?(:report_game_over)
        @interface.report_game_over(player_mark)
      else
        raise InterfaceError, "#{self.class}#report_game_over is not implemented"
      end
    end
  end
end