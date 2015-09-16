require_relative "human_player"
require_relative "computer_player"
require_relative "available_player_types"

module TicTacToe
  module PlayerFactory
    def self.build(config)
      case config[:type]
      when AvailablePlayerTypes::HUMAN
        create_human_player(config)
      when AvailablePlayerTypes::COMPUTER
        create_computer_player(config)
      end
    end

    private

    def self.create_human_player(config)
      human_parameters = {
        player_mark: config[:player_mark],
        interface: config[:game].interface
      }
      HumanPlayer.new(human_parameters)
    end

    def self.create_computer_player(config)
      computer_parameters = {
        player_mark: config[:player_mark],
        opponent_mark: (config[:game].player_marks - [config[:player_mark]]).pop,
        board: config[:game].board
      }
      ComputerPlayer.new(computer_parameters)
    end
  end
end