require 'spec_helper'

module TicTacToe
  describe ComputerPlayer do
    include_context 'default_values'
    include_context 'helper_methods'

    let(:ai) do
      described_class.new(
        board: new_board(@default_board_size),
        player_mark: @default_first_player,
        opponent_mark: @default_second_player)
    end
    let(:infinity) { Float::INFINITY }
    let(:neg_infinity) { -Float::INFINITY }

    it 'implements methods required by Player interface' do
      Player.required_methods.each do |method|
        expect(ai).to respond_to(method)
      end
    end

    describe '#initialize' do
      it 'takes a parameters hash with the player\'s mark, opponent\'s mark, and the game board' do
        params = {
          board: new_board(@default_board_size),
          player_mark: @default_first_player,
          opponent_mark: @default_second_player
        }

        expect { described_class.new(params) }.not_to raise_error
      end
    end

    describe '#move' do
      context 'when a center space is available' do
        it 'returns the move coordinate for centermost space' do
          [3, 5, 7].each do |odd_size|
            custom_ai = described_class.new(
              board: new_board(odd_size),
              player_mark: @default_first_player,
              opponent_mark: @default_second_player)

            expect(custom_ai.move).to eq [odd_size / 2, odd_size / 2]
          end
        end
      end

      context 'when a center space is not available' do
        before do
          center_coordinate = [ai.board.size / 2, ai.board.size / 2]
          ai.board[*center_coordinate] = ai.opponent_mark
        end

        it 'returns coordinates for the best available move' do
          expect(ai).to receive(:select_best_move)
          ai.move
        end
      end
    end

    describe '#select_best_move' do
      it 'returns the coordinates of an available move on the game board' do
        board = ai.board
        3.times do
          board[*board.blank_cell_coordinates.sample] = @default_player_marks.sample
        end
        coordinates = ai.select_best_move

        expect(board.marked?(coordinates)).to be false
      end

      it 'selects the move resulting in a board with the highest score when evaluated by minimax' do
        allow(ai).to receive(:minimax).and_return(1, 0)
        coordinates = ai.board.blank_cell_coordinates.first

        expect(ai.select_best_move).to eq coordinates
      end
    end

    describe '#generate_possible_successor_boards' do
      it 'returns new board objects that are distinct from given board' do
        ai.generate_possible_successor_boards(ai.board, ai.player_mark).each do |board|
          expect(board).not_to eq ai.board
        end
      end

      it 'returns a board for every blank cell in given board' do
        blank_cell_count = ai.board.blank_cell_coordinates.count
        board_count = ai.generate_possible_successor_boards(ai.board, ai.player_mark).count

        expect(board_count).to eq blank_cell_count
      end

      it 'returns boards marked once with given mark, in each of the blank cells' do
        boards = ai.generate_possible_successor_boards(ai.board, ai.player_mark)
        (0...ai.board.size).each do |row|
          (0...ai.board.size).each do |col|
            expect(boards.any? { |board| board.marked?([row, col]) }).to be true
          end
        end
      end
    end

    describe '#minimax' do
      let(:best_score_so_far) { {player: neg_infinity, opponent: infinity} }

      context 'when given a board that is won or ended in a draw' do
        let(:game_over_boards) do
          boards = all_wins(@default_board_size, ai.player_mark)
          boards += all_wins(@default_board_size, ai.opponent_mark)
          boards << board_with_draw(@default_board_size, [ai.player_mark, ai.opponent_mark])
        end

        it 'heuristically evaluates the desirability of given board' do
          allow(ai).to receive(:evaluate).and_return(0)

          game_over_boards.each do |board|
            expect(ai).to receive(:evaluate)
            expect(ai.minimax(board, true, best_score_so_far)).to eq 0
          end
        end

        it 'does not use recursive calls to #minimax' do
          game_over_boards.each do |board|
            expect(ai).to receive(:minimax).at_most(1).times
            ai.minimax(board, true, best_score_so_far)
          end
        end
      end

      context 'when given a board that is incomplete' do
        let(:board) do
          board_with_potential_win_loss_or_draw(@default_board_size, @default_player_marks)
        end

        context 'when it is computer\'s turn' do
          let(:my_turn) { true }

          it 'selects score of best board for computer player that can result next turn' do
            best_score = ai.select_score_of_best_successor_board(board, my_turn, best_score_so_far.dup)

            expect(ai.minimax(board, my_turn, best_score_so_far.dup)).to eq best_score
          end
        end

        context 'when it is computer\'s turn' do
          let(:my_turn) { false }

          it 'selects score of best board for opponent that can result next turn' do
            best_score = ai.select_score_of_best_successor_board(board, my_turn, best_score_so_far.dup)

            expect(ai.minimax(board, my_turn, best_score_so_far.dup)).to eq best_score
          end
        end
      end
    end

    describe '#evaluate' do
      it 'returns Infinity when given board is a win for computer player' do
        all_wins(@default_board_size, ai.player_mark).each do |winning_board|

          expect(ai.evaluate(winning_board)).to eq infinity
        end
      end

      it 'returns -Infinity when given board is a win for opponent' do
        all_wins(@default_board_size, ai.opponent_mark).each do |winning_board|

          expect(ai.evaluate(winning_board)).to eq neg_infinity
        end
      end

      it 'returns 0 if board is a draw' do
        board = board_with_draw(@default_board_size, [ai.player_mark, ai.opponent_mark])

        expect(ai.evaluate(board)).to eq 0
      end
    end

    describe '#select_score_of_best_successor_board' do
      let(:best_score_so_far) { {player: 0, opponent: 0} }

      it 'evaluates the boards that could result next turn from given board' do
        expect(ai).to receive(:score_successor_boards).at_least(1).times.and_call_original
        ai.select_score_of_best_successor_board(ai.board, true, best_score_so_far)
      end

      context 'when it is computer player\'s turn' do
        let(:my_turn) { true }

        it 'selects the greatest score from among the generated scores' do
          scores = [1, 0, -1]
          allow(ai).to receive(:score_successor_boards).and_return(scores)
          score = ai.select_score_of_best_successor_board(ai.board, my_turn, best_score_so_far)

          expect(score).to eq scores.max
        end
      end

      context 'when it is not computer player\'s turn' do
        let(:my_turn) { false }

        it 'selects the lowest score from among the generated scores' do
          scores = [1, 0, -1]
          allow(ai).to receive(:score_successor_boards).and_return(scores)
          score = ai.select_score_of_best_successor_board(ai.board, my_turn, best_score_so_far)

          expect(score).to eq scores.min
        end
      end
    end

    describe '#score_successor_boards' do
      let(:successor_boards) { ai.generate_possible_successor_boards(ai.board, ai.player_mark) }
      let(:best_score_so_far) { {player: -1, opponent: 1} }

      it 'updates the best score so far after scoring each board' do
        allow(ai).to receive(:minimax)
        num_boards = successor_boards.count

        expect(ai).to receive(:update_best_score_so_far).exactly(num_boards).times
        ai.score_successor_boards(successor_boards, true, best_score_so_far)
      end

      context 'when it is computer player\'s turn' do
        let(:my_turn) { true }

        context 'when a score proves previous player will select a different initial move' do
          let(:worse_score_for_prev_player) { best_score_so_far[:opponent] + 1 }

          it 'returns scores of boards evaluated up to that point' do
            allow(ai).to receive(:minimax).and_return(worse_score_for_prev_player)
            scores = ai.score_successor_boards(successor_boards, my_turn, best_score_so_far)

            expect(scores.count).to be < successor_boards.count
          end
        end

        context 'when a worse scoring board for previous player is not present' do
          let(:better_score_for_prev_player) { best_score_so_far[:opponent] - 1}

          it 'returns scores of all given boards' do
            allow(ai).to receive(:minimax).and_return(better_score_for_prev_player)
            scores = ai.score_successor_boards(successor_boards, my_turn, best_score_so_far)

            expect(scores.count).to eq successor_boards.count
          end
        end
      end

      context 'when it is not computer player\'s turn' do
        let(:my_turn) { false }

        context 'when a score guarantees previous player will select a different initial move' do
          let(:worse_score_for_prev_player) { best_score_so_far[:player] - 1 }

          it 'returns scores of boards evaluated up to that point' do
            allow(ai).to receive(:minimax).and_return(worse_score_for_prev_player)
            scores = ai.score_successor_boards(successor_boards, my_turn, best_score_so_far)

            expect(scores.count).to be < successor_boards.count
          end
        end

        context 'when a worse scoring board for previous player is not present' do
          let(:better_score_for_prev_player) { best_score_so_far[:player] + 1}

          it 'returns scores of all given boards' do
            allow(ai).to receive(:minimax).and_return(better_score_for_prev_player)
            scores = ai.score_successor_boards(successor_boards, my_turn, best_score_so_far)

            expect(scores.count).to eq successor_boards.count
          end
        end
      end
    end

    describe '#update_best_score_so_far' do
      let(:best_score_so_far) { {player: 0, opponent: 0} }

      context 'when it is computer player\'s turn' do
        let(:my_turn) { true }

        it 'leaves best score so far for opponent unchanged' do
          initial_best_score_for_opponent = best_score_so_far[:opponent]
          scores = [-1, 0, 1]

          scores.each do |score|
            ai.update_best_score_so_far(my_turn, best_score_so_far, score)
            expect(best_score_so_far[:opponent]).to eq initial_best_score_for_opponent
          end
        end

        context 'when given score is greater than best score so far for computer player' do
          let(:higher_score) { 1 }

          it 'replaces best score so far for player with given score' do
            ai.update_best_score_so_far(my_turn, best_score_so_far, higher_score)
            expect(best_score_so_far[:player]).to eq higher_score
          end
        end

        context 'when given score is not greater than best score so far for computer player' do
          let(:lower_score) { -1 }

          it 'leaves best score so far for player unchanged' do
            ai.update_best_score_so_far(my_turn, best_score_so_far, lower_score)
            expect(best_score_so_far[:player]).not_to eq lower_score
          end
        end
      end

      context 'when it is not computer player\'s turn' do
        let(:my_turn) { false }

        it 'leaves best score so far for computer player unchanged' do
          initial_best_score_for_player = best_score_so_far[:player]
          scores = [-1, 0, 1]

          scores.each do |score|
            ai.update_best_score_so_far(my_turn, best_score_so_far, score)
            expect(best_score_so_far[:player]).to eq initial_best_score_for_player
          end
        end

        context 'when given score is lower than best score so far for opponent' do
          let(:lower_score) { -1 }

          it 'replaces best score so far for opponent with given score' do
            ai.update_best_score_so_far(my_turn, best_score_so_far, lower_score)
            expect(best_score_so_far[:opponent]).to eq lower_score
          end
        end

        context 'when given score is not lower than best score so far for opponent' do
          let(:higher_score) { 1 }

          it 'leaves best score so far for opponent unchanged' do
            ai.update_best_score_so_far(my_turn, best_score_so_far, higher_score)
            expect(best_score_so_far[:opponent]).not_to eq higher_score
          end
        end
      end
    end
  end
end
