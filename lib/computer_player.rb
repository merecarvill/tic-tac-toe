require 'player_interface'

module TicTacToe
  class ComputerPlayer < PlayerInterface
    attr_reader :mark

    def initialize(mark)
      @mark = mark
    end

    def move
    end
  end
end