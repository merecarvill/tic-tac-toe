require 'spec_helper'

module TicTacToe
  describe ComputerPlayer do
    include_context 'default_values'
    include_context 'helper_methods'

    let(:ai) do
      described_class.new(
        board: new_board(@default_board_size),
        player: @default_first_player,
        opponent: @default_second_player)
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
          player: @default_first_player,
          opponent: @default_second_player
        }

        expect { described_class.new(params) }.not_to raise_error
      end
    end

    describe '#move' do
      context 'when a center space is available' do
        it 'returns the move coordinate for centermost space' do
          odd_size_board = new_board(3)
          custom_ai = described_class.new(
            board: odd_size_board,
            player: @default_first_player,
            opponent: @default_second_player)

          expect(ai.move).to eq [ai.board.size / 2, ai.board.size / 2]
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

          allow(ai).to receive(:minimax) do |game_state|
            row, col = game_state.last_move
            row + col
          end

          expect(ai.move).to eq [ai.board.size - 1, ai.board.size - 1]
        end
      end
    end

    describe '#minimax' do
      let(:infinity) { Float::INFINITY }
      let(:neg_infinity) { -Float::INFINITY }

      it 'returns Infinity when given game state is a win for computer player' do
        all_wins(@default_board_size, ai.player_mark).each do |winning_board|
          game_state = GameState.new(
            board: winning_board,
            current_player: ai.player_mark,
            opponent: ai.opponent_mark
          )

          expect(ai.minimax(game_state, neg_infinity, infinity)).to eq infinity
        end
      end

      it 'returns -Infinity when given game state is a win for opponent' do
        all_wins(@default_board_size, ai.opponent_mark).each do |winning_board|
          game_state = GameState.new(
            board: winning_board,
            current_player: ai.player_mark,
            opponent: ai.opponent_mark
          )

          expect(ai.minimax(game_state, neg_infinity, infinity)).to eq neg_infinity
        end
      end

      it 'returns 0 if game state is a draw' do
        board = board_with_draw(@default_board_size, [ai.player_mark, ai.opponent_mark])
        game_state = GameState.new(
          board: board,
          current_player: ai.player_mark,
          opponent: ai.opponent_mark)

        expect(ai.minimax(game_state, neg_infinity, infinity)).to eq 0
      end

      context 'when given a game state that is incomplete' do
        let(:board) do
          board_with_potential_win_loss_or_draw(@default_board_size, @default_player_marks)
        end

        it 'recursively calls minimax on possible subsequent game states to determine a score' do
          marked_coordinates = all_coordinates(board.size) - board.blank_cell_coordinates
          initial_game_state = GameState.new(
            board: board,
            current_player: ai.player_mark,
            opponent: ai.opponent_mark)

          expect(ai).to receive(:minimax).at_least(:twice)
          allow(ai).to receive(:minimax).and_call_original do |game_state|
            marked_coordinates.each do |coordinate|
              expect(game_state.board[*coordinate]).to eq board[*coordinate]
            end
          end
          expect(ai.minimax(initial_game_state, neg_infinity, infinity)).not_to be nil
        end

        context 'when current player is computer player' do
          let(:game_state) do
            game_state = GameState.new(
              board: board,
              current_player: ai.player_mark,
              opponent: ai.opponent_mark)
          end

          it 'returns greatest score from among game states that can result from current turn' do
            child_state_scores = board.blank_cell_coordinates.map do |coord|
              ai.minimax(game_state.make_move(coord), neg_infinity, infinity)
            end
            highest_score = child_state_scores.max

            expect(ai.minimax(game_state, neg_infinity, infinity)).to eq highest_score
          end

          it 'stops evaluating subsequent game states when a better choice is already available' do
            best_score_so_far_for_max = 1
            allow(ai).to receive(:evaluate).and_return(0)

            expect(ai).to receive(:evaluate).exactly(3).times
            ai.minimax(game_state, best_score_so_far_for_max, infinity)
          end
        end

        context 'when current player is not the computer player' do
          let(:game_state) do
            game_state = GameState.new(
              board: board,
              current_player: ai.opponent_mark,
              opponent: ai.player_mark)
          end

          it 'returns lowest score from among game states that can result from current turn' do
            child_state_scores = board.blank_cell_coordinates.map do |coord|
              ai.minimax(game_state.make_move(coord), neg_infinity, infinity)
            end
            lowest_score = child_state_scores.min

            expect(ai.minimax(game_state, neg_infinity, infinity)).to eq lowest_score
          end

          it 'stops evaluating subsequent game states when a better choice is already available' do
            best_score_so_far_for_min = -1
            allow(ai).to receive(:evaluate).and_return(0)

            expect(ai).to receive(:evaluate).exactly(3).times
            ai.minimax(game_state, neg_infinity, best_score_so_far_for_min)
          end
        end
      end
    end
  end
end
