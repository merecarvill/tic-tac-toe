require 'board'
require 'player'
require 'interface'

module TicTacToe
  class Game

    attr_reader :interface, :board, :player_marks, :players

    def initialize(parameters)
      @player_marks = parameters[:player_marks] || [:x, :o]
      board_size = parameters[:board_size] || 3
      @board = TicTacToe::Board.new(size: board_size)
      @interface = TicTacToe::Interface.new(:command_line)
      @players = []
    end

    def set_up
      player_types = @interface.game_setup_interaction(@player_marks)

      @player_marks.zip(player_types).each do |mark, type|
        @players << create_player(mark, type)
      end
    end

    def create_player(mark, type)
      TicTacToe::Player.new(
        player: mark,
        type: type,
        interface: @interface,
        board: @board,
        opponent: (@player_marks - [mark]).pop)
    end

    def handle_one_turn(current_player)
      @interface.show_game_board(@board)
      coordinates = get_valid_move(current_player)
      @board[*coordinates] = current_player.player_mark
      @interface.report_move(current_player.player_mark, coordinates)
    end

    def get_valid_move(player)
      board = @board.deep_copy
      begin
        coordinates = player.move
        board[*coordinates] = player.player_mark
        coordinates
      rescue TicTacToe::Board::BoardError => msg
        @interface.report_invalid_move(coordinates, msg)
        retry
      end
    end
  end
end