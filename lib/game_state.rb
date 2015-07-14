module TicTacToe
  class GameState

    def initialize(parameters)
      @board = parameters[:board]
      @player = parameters[:player]
      @opponent = parameters[:opponent]
    end
  end
end