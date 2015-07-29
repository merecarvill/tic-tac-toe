require_relative 'computer_player'
require_relative 'human_player'

module TicTacToe
  class Player
    PlayerError = Class.new(StandardError)

    attr_reader :player

    def self.required_methods
      [:move, :player_mark]
    end

    def initialize(parameters)
      case parameters[:type]
      when :human
        @player = HumanPlayer.new(parameters)
      when :computer
        @player = ComputerPlayer.new(parameters)
      else
        fail PlayerError, "Attempted to initialize player with invalid type: #{parameters[:type]}"
      end
    end

    def player_mark
      if @player.respond_to?(:player_mark)
        @player.player_mark
      else
        fail PlayerError, "#{self.class}#player_mark is not implemented"
      end
    end

    def move
      if @player.respond_to?(:move)
        @player.move
      else
        fail PlayerError, "#{self.class}#move is not implemented"
      end
    end
  end
end
