module TicTacToe
  class GameState
    attr_accessor :rank
    attr_reader :board, :last_move, :player_mark, :opponent_mark

    def initialize(parameters)
      @board = parameters[:board]
      @player_mark = parameters[:current_player]
      @opponent_mark = parameters[:opponent]
      @last_move = parameters[:last_move]
    end

    def make_move(coordinate)
      new_board = @board.deep_copy
      new_board[*coordinate] = @player_mark
      GameState.new(
        board: new_board,
        current_player: @opponent_mark,
        opponent: @player_mark,
        last_move: coordinate
      )
    end
  end
end