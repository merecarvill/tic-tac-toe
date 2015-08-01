module TicTacToe
  class ComputerPlayer
    attr_reader :player_mark, :opponent_mark, :board

    def initialize(parameters)
      @player_mark = parameters[:player_mark]
      @opponent_mark = parameters[:opponent_mark]
      @board = parameters[:board]
    end

    def move
      center_coordinate = [@board.size / 2, @board.size / 2]
      if !@board.marked?(center_coordinate) && @board.size.odd?
        center_coordinate
      else
        select_best_move
      end
    end

    def select_best_move
      best_score_so_far = {
        player: -Float::INFINITY, # highest score is best for player
        opponent: Float::INFINITY # lowest score is best for opponent
      }

      child_boards = generate_possible_successor_boards(@board, @player_mark)
      best_board = child_boards.max_by { |board| minimax(board, false, best_score_so_far) }
      best_board.last_move_made
    end

    def generate_possible_successor_boards(board, mark)
      board.blank_cell_coordinates.map do |coordinates|
        child_board = board.deep_copy
        child_board[*coordinates] = mark
        child_board
      end
    end

    def minimax(board, my_turn, best_score_so_far)
      if board.game_over?
        evaluate(board)
      else
        recursively_evaluate(board, my_turn, best_score_so_far.dup)
      end
    end

    def evaluate(board)
      board.lines.each do |line|
        return Float::INFINITY if line.all? { |cell| cell == @player_mark }
        return -Float::INFINITY if line.all? { |cell| cell == @opponent_mark }
      end
      0
    end

    def recursively_evaluate(board, my_turn, best_score_so_far)
      scores = find_scores_for_child_boards(board, my_turn, best_score_so_far)
      my_turn ? scores.max : scores.min
    end

    def find_scores_for_child_boards(board, my_turn, best_score_so_far)
      current_player_mark = my_turn ? @player_mark : @opponent_mark

      child_board_scores = []
      catch(:best_score_found) do
        generate_possible_successor_boards(board, current_player_mark).each do |board|
          score = minimax(board, !my_turn, best_score_so_far.dup)
          child_board_scores << score

          update_best_score_so_far(my_turn, best_score_so_far, score)
          stop_if_best_score_found(best_score_so_far)
        end
      end
      child_board_scores
    end

    def update_best_score_so_far(my_turn, best_score_so_far, score)
      if score > best_score_so_far[:player] && my_turn
        best_score_so_far[:player] = score
      end
      if score < best_score_so_far[:opponent] && !my_turn
        best_score_so_far[:opponent] = score
      end
    end

    def stop_if_best_score_found(best_score_so_far)
      throw(:best_score_found) if best_score_so_far[:player] >= best_score_so_far[:opponent]
    end
  end
end
