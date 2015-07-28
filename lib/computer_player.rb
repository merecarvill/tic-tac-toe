require_relative 'game_state'

module TicTacToe
  class ComputerPlayer

    attr_reader :player_mark, :opponent_mark, :board

    def initialize(parameters)
      @player_mark = parameters[:player]
      @opponent_mark = parameters[:opponent]
      @board = parameters[:board]
    end

    def move
      game_state = TicTacToe::GameState.new(
        board: @board,
        current_player: @player_mark,
        opponent: @opponent_mark)
      child_states = @board.blank_cell_coordinates.map{ |coord| game_state.make_move(coord) }
      child_states.max_by{ |state| minimax(state) }.last_move
    end

    def minimax(game_state)
      if game_state.game_over?
        evaluate(game_state)
      else
        recursively_determine_minimax_score(game_state)
      end
    end

    private

    def recursively_determine_minimax_score(game_state)
      child_state_scores = game_state.board.blank_cell_coordinates.map do |coordinate|
        minimax(game_state.make_move(coordinate))
      end
      if game_state.player_mark == @player_mark
        child_state_scores.max
      else
        child_state_scores.min
      end
    end

    def evaluate(game_state)
      game_state.board.lines.each do |line|
        return Float::INFINITY if line.all?{ |cell| cell == @player_mark }
        return -Float::INFINITY if line.all?{ |cell| cell == @opponent_mark }
      end

      game_state.board.filled? ? 0 : nil
    end
  end
end