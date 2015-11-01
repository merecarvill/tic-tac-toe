require "human_player"
require "computer_player"
require "available_player_types"

module TicTacToe
  module PlayerFactory
    def self.build(parameters)
      case parameters[:type]
      when AvailablePlayerTypes::HUMAN
        create_human_player(parameters)
      when AvailablePlayerTypes::COMPUTER
        create_computer_player(parameters)
      end
    end

    private

    def self.create_human_player(parameters)
      human_parameters = {
        player_mark: parameters[:player_mark],
        interface: parameters[:game].interface
      }
      HumanPlayer.new(human_parameters)
    end

    def self.create_computer_player(parameters)
      computer_parameters = {
        player_mark: parameters[:player_mark],
        opponent_mark: (parameters[:game].player_marks - [parameters[:player_mark]]).pop,
        board: parameters[:game].board
      }
      ComputerPlayer.new(computer_parameters)
    end
  end
end