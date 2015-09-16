require_relative 'negamax'

module TicTacToe
  class ComputerPlayerII
    def initialize(parameters)
      @board = parameters[:board]
      @player_mark = parameters[:player_mark]
      @opponent_mark = parameters[:opponent_mark]
    end

    def move
      if @board.all_blank? && @board.size.odd?
        [:row, :col].map { @board.size / 2 }
      else
        @board.blank_cell_coordinates.sample
      end
    end
  end
end