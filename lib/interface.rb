require 'command_line_interface'

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
  end
end