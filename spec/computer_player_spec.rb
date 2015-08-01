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
        it 'returns a move coordinate that is not already marked on the game board' do
          all_coordinates(ai.board.size).each do |coordinate|
            ai.board[*coordinate] = ai.player_mark unless coordinate == [0, 0]
          end

          expect(ai.move).to eq [0, 0]
        end

        it 'returns move coordinate for game state that produces greatest score when passed to minimax' do
          center_coordinate = [ai.board.size / 2, ai.board.size / 2]
          ai.board[*center_coordinate] = ai.opponent_mark

          allow(ai).to receive(:minimax) do |board|
            row, col = board.last_move_made
            row + col
          end

          expect(ai.move).to eq [ai.board.size - 1, ai.board.size - 1]
        end
      end
    end

    describe '#minimax' do
      let(:infinity) { Float::INFINITY }
      let(:neg_infinity) { -Float::INFINITY }
      let(:best_score_so_far) { {player: neg_infinity, opponent: infinity} }

      it 'returns Infinity when given game state is a win for computer player' do
        all_wins(@default_board_size, ai.player_mark).each do |winning_board|

          expect(ai.minimax(winning_board, true, best_score_so_far)).to eq infinity
        end
      end

      it 'returns -Infinity when given game state is a win for opponent' do
        all_wins(@default_board_size, ai.opponent_mark).each do |winning_board|

          expect(ai.minimax(winning_board, false, best_score_so_far)).to eq neg_infinity
        end
      end

      it 'returns 0 if game state is a draw' do
        board = board_with_draw(@default_board_size, [ai.player_mark, ai.opponent_mark])

        expect(ai.minimax(board, true, best_score_so_far)).to eq 0
        expect(ai.minimax(board, false, best_score_so_far)).to eq 0
      end

      context 'when given a game state that is incomplete' do
        let(:board) do
          board_with_potential_win_loss_or_draw(@default_board_size, @default_player_marks)
        end

        it 'recursively calls minimax on possible subsequent game states to determine a score' do
          marked_coordinates = all_coordinates(board.size) - board.blank_cell_coordinates

          expect(ai).to receive(:minimax).at_least(:twice)
          allow(ai).to receive(:minimax).and_call_original do |passed_board|
            marked_coordinates.each do |coordinate|
              expect(passed_board[*coordinate]).to eq board[*coordinate]
            end
          end
          expect(ai.minimax(board, true, best_score_so_far)).not_to be nil
        end

        context 'when current player is computer player' do
          it 'returns greatest score from among game states that can result from current turn' do
            child_state_scores = ai.generate_possible_successor_boards(board, ai.player_mark).map do |child_board|
              ai.minimax(child_board, true, best_score_so_far.dup)
            end
            highest_score = child_state_scores.max

            expect(ai.minimax(board, true, best_score_so_far)).to eq highest_score
          end

          it 'stops evaluating subsequent game states when a better choice is already available' do
            best_score_so_far[:player] = 1
            allow(ai).to receive(:evaluate).and_return(0)

            expect(ai).to receive(:evaluate).exactly(3).times
            ai.minimax(board, true, best_score_so_far)
          end
        end

        context 'when current player is not the computer player' do
          it 'returns lowest score from among game states that can result from current turn' do
            child_state_scores = ai.generate_possible_successor_boards(board, ai.opponent_mark).map do |child_board|
              ai.minimax(child_board, false, best_score_so_far.dup)
            end
            lowest_score = child_state_scores.min

            expect(ai.minimax(board, false, best_score_so_far)).to eq lowest_score
          end

          it 'stops evaluating subsequent game states when a better choice is already available' do
            best_score_so_far[:opponent] = -1
            allow(ai).to receive(:evaluate).and_return(0)

            expect(ai).to receive(:evaluate).exactly(3).times
            ai.minimax(board, false, best_score_so_far)
          end
        end
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
  end
end
