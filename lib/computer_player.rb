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

      successor_boards = generate_possible_successor_boards(@board, @player_mark)
      best_board = successor_boards.max_by { |board| minimax(board, false, best_score_so_far) }
      best_board.last_move_made
    end

    def generate_possible_successor_boards(board, mark)
      board.blank_cell_coordinates.map do |coordinates|
        successor_board = board.deep_copy
        successor_board.mark_cell(mark, *coordinates)
        successor_board
      end
    end

    def minimax(board, my_turn, best_score_so_far)
      if board.has_winning_line? || board.all_marked?
        evaluate(board)
      else
        select_score_of_best_successor_board(board, my_turn, best_score_so_far.dup)
      end
    end

    def evaluate(board)
      board.lines.each do |line|
        return Float::INFINITY if line.all? { |cell| cell == @player_mark }
        return -Float::INFINITY if line.all? { |cell| cell == @opponent_mark }
      end
      0
    end

    def select_score_of_best_successor_board(board, my_turn, best_score_so_far)
      current_player_mark = my_turn ? @player_mark : @opponent_mark

      successor_boards = generate_possible_successor_boards(board, current_player_mark)
      scores = score_successor_boards(successor_boards, my_turn, best_score_so_far)

      my_turn ? scores.max : scores.min
    end

    def score_successor_boards(successor_boards, my_turn, best_score_so_far)
      successor_boards.each_with_object([]) do |board, scores|
        score = minimax(board, !my_turn, best_score_so_far.dup)
        scores << score

        update_best_score_so_far(my_turn, best_score_so_far, score)
        return scores if best_score_guaranteed_elsewhere?(best_score_so_far)
      end
    end

    def update_best_score_so_far(my_turn, best_score_so_far, score)
      if score > best_score_so_far[:player] && my_turn
        best_score_so_far[:player] = score
      end
      if score < best_score_so_far[:opponent] && !my_turn
        best_score_so_far[:opponent] = score
      end
    end

    def best_score_guaranteed_elsewhere?(best_score_so_far)
      best_score_so_far[:player] >= best_score_so_far[:opponent]
    end
  end
end
