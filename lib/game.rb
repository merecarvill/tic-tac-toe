require_relative 'board'
require_relative 'player'
require_relative 'interface'

module TicTacToe
  class Game
    attr_reader :interface, :board, :player_marks, :players

    def initialize(parameters)
      @player_marks = parameters[:player_marks] || [:x, :o]
      board_size = parameters[:board_size] || 3
      @board = Board.new(size: board_size)
      @interface = Interface.new(:command_line)
      @players = []
    end

    def run
      set_up
      handle_turns
      handle_game_over
    end

    def set_up
      player_types = @interface.game_setup_interaction(@player_marks)

      @player_marks.zip(player_types).each do |mark, type|
        @players << create_player(mark, type)
      end
    end

    def create_player(mark, type)
      Player.new(
        player: mark,
        type: type,
        interface: @interface,
        board: @board,
        opponent: (@player_marks - [mark]).pop)
    end

    def handle_turns
      catch(:game_over) do
        @players.cycle do |current_player|
          handle_one_turn(current_player)
          throw :game_over if over?
        end
      end
    end

    def handle_one_turn(current_player)
      @interface.show_game_board(@board)
      coordinates = get_valid_move(current_player)
      @board[*coordinates] = current_player.player_mark
      @interface.report_move(current_player.player_mark, coordinates)
    end

    def get_valid_move(player)
      loop do
        coordinates = player.move
        if coordinates.any? { |i| !i.between?(0, @board.size - 1) } || @board.marked?(coordinates)
          @interface.report_invalid_move(coordinates)
        else
          return coordinates
        end
      end
    end

    def handle_game_over
      @interface.show_game_board(@board)
      winning_player_mark = @board.has_winning_line? ? @board.last_mark_made : :none
      @interface.report_game_over(winning_player_mark)
    end

    def over?
      @board.has_winning_line? || @board.filled?
    end
  end
end
