module TicTacToe
  class HumanPlayer
    attr_reader :player_mark

    def initialize(parameters)
      @player_mark = parameters.fetch(:player_mark)
    end

    def move(game)
      game.interface.solicit_move(@player_mark)
    end
  end
end
