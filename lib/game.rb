require "board"
require "player_factory"
require "command_line_interface"

module TicTacToe
  class Game
    attr_reader :interface, :board, :player_marks, :players

    def initialize(parameters)
      @player_marks = parameters[:player_marks] || [:x, :o]
      @board = parameters[:board] || create_default_board
      @interface = parameters[:interface] || create_default_interface
      @players = []
    end

    def run
      set_up
      handle_turns
      handle_game_over
    end

    def set_up
      player_types = @interface.game_setup_interaction(@player_marks)

      @players = @player_marks.zip(player_types).map { |mark, type| create_player(mark, type) }
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
      @board = @board.mark_space(current_player.player_mark, coordinates)
      @interface.report_move(current_player.player_mark, coordinates)
    end

    def get_valid_move(player)
      loop do
        coordinates = player.move(self)
        if @board.out_of_bounds?(coordinates) || @board.marked?(coordinates)
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
      @board.has_winning_line? || @board.all_marked?
    end

    private

    def create_default_board
      Board.new(size: 3)
    end

    def create_default_interface
      parameters = {
        input: $stdin,
        output: $stdout
      }
      CommandLineInterface.new(parameters)
    end

    def create_player(mark, type)
      player_config = {
        type: type,
        game: self,
        player_mark: mark
      }
      PlayerFactory.build(player_config)
    end
  end
end
