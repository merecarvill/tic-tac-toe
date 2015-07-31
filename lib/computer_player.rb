module TicTacToe
  class ComputerPlayer
    attr_reader :player_mark, :opponent_mark, :board

    def initialize(parameters)
      @player_mark = parameters[:player]
      @opponent_mark = parameters[:opponent]
      @board = parameters[:board]
    end

    def move
      center_coordinate = [@board.size / 2, @board.size / 2]
      if !@board.marked?(center_coordinate) && @board.size.odd?
        center_coordinate
      else
        child_boards = generate_possible_successor_boards(@board, @player_mark)
        best_score_so_far = {
          player: -Float::INFINITY, # highest score is best for player
          opponent: Float::INFINITY # lowest score is best for opponent
        }
        child_boards.max_by { |board| minimax(board, @opponent_mark, best_score_so_far) }.last_move_made
      end
    end

    def generate_possible_successor_boards(board, mark)
      board.blank_cell_coordinates.map do |coordinates|
        child_board = board.deep_copy
        child_board[*coordinates] = mark
        child_board
      end
    end

    def minimax(board, current_player, best_score_so_far)
      if board.game_over?
        evaluate(board)
      else
        recursively_evaluate(board, current_player, best_score_so_far.dup)
      end
    end

    def recursively_evaluate(board, current_player, best_score_so_far)
      next_player = current_player == @player_mark ? @opponent_mark : @player_mark
      child_board_scores = []
      generate_possible_successor_boards(board, current_player).each do |board|
        score = minimax(board, next_player, best_score_so_far.dup)
        child_board_scores << score
        best_score_so_far[:player] = score if score > best_score_so_far[:player] && current_player == @player_mark
        best_score_so_far[:opponent] = score if score < best_score_so_far[:opponent] && current_player == @opponent_mark
        break if best_score_so_far[:player] >= best_score_so_far[:opponent]
      end

      if current_player == @player_mark
        child_board_scores.max
      else
        child_board_scores.min
      end
    end

    def evaluate(board)
      board.lines.each do |line|
        return Float::INFINITY if line.all? { |cell| cell == @player_mark }
        return -Float::INFINITY if line.all? { |cell| cell == @opponent_mark }
      end
      0
    end
  end
end
