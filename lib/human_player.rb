module TicTacToe
  class HumanPlayer
    attr_reader :player_mark

    def initialize(parameters)
      @player_mark = parameters[:player_mark]
      @interface = parameters[:interface]
    end

    def move
      @interface.solicit_move(@player_mark)
    end
  end
end
