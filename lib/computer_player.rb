require 'player_interface'
require 'game_state'

module TicTacToe
  class ComputerPlayer < PlayerInterface

    attr_reader :player_mark, :opponent_mark

    def initialize(parameters)
      @player_mark = parameters[:player]
      @opponent_mark = parameters[:opponent]
      @board = parameters[:board]
    end

    def minimax_score(game_state)
      game_state.board.lines.each do |line|
        return 1 if line.all?{ |cell| cell == @player_mark }
        return -1 if line.all?{ |cell| cell == @opponent_mark }
      end

      return 0 if game_state.board.filled?
      return nil
    end
  end
end