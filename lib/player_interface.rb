require 'computer_player'

module TicTacToe
  class PlayerInterface
    InterfaceError = Class.new(StandardError)

    def self.required_methods
      [:move, :player_mark]
    end

    def initialize(parameters)
      case parameters[:type]
      when :computer
        @player = ComputerPlayer.new(parameters)
      end
    end

    def player_mark
      if @player.respond_to?(:player_mark)
        @player.player_mark
      else
        raise InterfaceError, "#{self.class}#player_mark is not implemented"
      end
    end

    def move
      if @player.respond_to?(:move)
        @player.move
      else
        raise InterfaceError, "#{self.class}#move is not implemented"
      end
    end
  end
end