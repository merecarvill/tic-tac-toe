require 'player_interface'

module TicTacToe
  class ComputerPlayer < PlayerInterface
    attr_reader :mark

    def initialize(perameters)
      @mark = perameters[:mark]
      @board = perameters[:board]
    end

    def move
    end
  end
end