require_relative 'human_player'
require_relative 'computer_player'

module TicTacToe
  class PlayerFactory
    def self.build(config)
      shared_parameters = {player_mark: config[:player_mark]}

      case config[:type]
      when :human
        human_parameters = {
          interface: config[:game].interface
        }
        HumanPlayer.new(human_parameters.merge(shared_parameters))
      when :computer
        computer_parameters = {
          opponent_mark: (config[:game].player_marks - [config[:player_mark]]).pop,
          board: config[:game].board
        }
        ComputerPlayer.new(computer_parameters.merge(shared_parameters))
      end
    end
  end
end