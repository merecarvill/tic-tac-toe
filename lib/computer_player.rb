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
      if @board.blank_cell_coordinates.include?([@board.size / 2, @board.size / 2]) && @board.size.odd?
        [@board.size / 2, @board.size / 2]
      else
        game_state = create_game_state
        child_states = @board.blank_cell_coordinates.map { |coord| game_state.make_move(coord) }
        child_states.max_by { |state| minimax(state, -Float::INFINITY, Float::INFINITY) }.last_move
      end
    end

    def create_game_state
      GameState.new(
        board: @board,
        current_player: @player_mark,
        opponent: @opponent_mark)
    end

    def minimax(game_state, highest_score, lowest_score)
      if game_state.game_over?
        evaluate(game_state)
      else
        recursively_determine_minimax_score(game_state, highest_score, lowest_score)
      end
    end

    def recursively_determine_minimax_score(game_state, highest_score, lowest_score)
      child_state_scores = []
      game_state.board.blank_cell_coordinates.each do |coordinate|
        score = minimax(game_state.make_move(coordinate), highest_score, lowest_score)
        child_state_scores << score
        highest_score = score if score > highest_score && game_state.player_mark == @player_mark
        lowest_score = score if score < lowest_score && game_state.player_mark == @opponent_mark
        break if highest_score >= lowest_score
      end
      if game_state.player_mark == @player_mark
        child_state_scores.max
      else
        child_state_scores.min
      end
    end

    def evaluate(game_state)
      game_state.board.lines.each do |line|
        return Float::INFINITY if line.all? { |cell| cell == @player_mark }
        return -Float::INFINITY if line.all? { |cell| cell == @opponent_mark }
      end

      game_state.board.filled? ? 0 : nil
    end
  end
end
