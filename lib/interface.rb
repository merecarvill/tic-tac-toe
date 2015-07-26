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

    def set_up_game(player_marks)
      if @interface.respond_to?(:set_up_game)
        @interface.set_up_game(player_marks)
      else
        raise InterfaceError, "#{self.class}#set_up_game is not implemented"
      end
    end
  end
end