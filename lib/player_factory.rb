require_relative 'human_player'
require_relative 'computer_player'

module TicTacToe
  class PlayerFactory
    def initialize(parameters)
      @game = parameters[:game]
    end

    def build(parameters)
      player_parameters = {
        player_mark: parameters[:player_mark],
        opponent_mark: parameters[:opponent_mark]
      }

      case parameters[:type]
      when :human
        player_parameters[:interface] = @game.interface
        HumanPlayer.new(player_parameters)
      when :computer
        player_parameters[:board] = @game.board
        ComputerPlayer.new(player_parameters)
      end
    end
  end
end