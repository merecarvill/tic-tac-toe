require 'spec_helper'

describe TicTacToe::ComputerPlayer do
  include_context "helper_methods"
  include_context "default_values"

  let(:ai) {
    described_class.new(
      board: new_board(@default_board_size),
      player: @default_first_player,
      opponent: @default_second_player)
  }

  it 'implements PlayerInterface' do
    TicTacToe::PlayerInterface.required_methods.each do |method|
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

      expect{ described_class.new(params) }.not_to raise_error
    end
  end

  describe '#minimax' do

    it 'returns 1 when given game state is a win for computer player' do
      all_wins(@default_board_size, ai.player_mark).each do |winning_board|
        game_state = TicTacToe::GameState.new(
          board: winning_board,
          current_player: ai.player_mark,
          opponent: ai.opponent_mark
        )

        expect(ai.minimax(game_state)).to eq 1
      end
    end

    it 'returns -1 when given game state is a win for opponent' do
      all_wins(@default_board_size, ai.opponent_mark).each do |winning_board|
        game_state = TicTacToe::GameState.new(
          board: winning_board,
          current_player: ai.player_mark,
          opponent: ai.opponent_mark
        )

        expect(ai.minimax(game_state)).to eq -1
      end
    end

    it 'returns 0 if game state is a draw' do
      board = board_with_draw(@default_board_size, ai.player_mark, ai.opponent_mark)
      game_state = TicTacToe::GameState.new(
        board: board,
        current_player: ai.player_mark,
        opponent: ai.opponent_mark)

      expect(ai.minimax(game_state)).to eq 0
    end

    context 'when given a game state that is incomplete' do

      it 'recursively calls minimax on possible subsequent game states to determine a score' do
        board = new_board(@default_board_size)
        board[0,0] = @default_first_player
        board[0, board.size - 1] = @default_second_player
        marked_coordinates = [[0, 0], [0, board.size - 1]]

        initial_game_state = TicTacToe::GameState.new(
          board: board,
          current_player: ai.player_mark,
          opponent: ai.opponent_mark)

        expect(ai).to receive(:minimax).at_least(:twice)
        allow(ai).to receive(:minimax).and_call_original do |game_state|
          marked_coordinates.each do |coordinate|
            expect(game_state.board[*coordinate]).to eq board[*coordinate]
          end
        end
        expect(ai.minimax(initial_game_state)).not_to be nil
      end

      context 'when current player is computer player' do
        it 'returns greatest score from among game states that can result from current turn' do
          board = new_board(@default_board_size)
          board[0, 0] = :x
          board[1, 0] = :o
          board[0, 1] = :x
          board[1, 1] = :o
          board[2, 0] = :x
          board[2, 1] = :o

          game_state = TicTacToe::GameState.new(
            board: board,
            current_player: ai.player_mark,
            opponent: ai.opponent_mark)

          child_state_scores = board.blank_cell_coordinates.map do |coord|
            ai.minimax(game_state.make_move(coord))
          end
          highest_score = child_state_scores.max

          expect(ai.minimax(game_state)).to eq highest_score
        end
      end

      context 'when current player is not the computer player' do
        it 'returns lowest score from among game states that can result from current turn' do
          board = new_board(@default_board_size)
          board[0, 0] = :x
          board[1, 0] = :o
          board[0, 1] = :x
          board[1, 1] = :o
          board[2, 0] = :x
          board[2, 1] = :o

          game_state = TicTacToe::GameState.new(
            board: board,
            current_player: ai.opponent_mark,
            opponent: ai.player_mark)

          child_state_scores = board.blank_cell_coordinates.map do |coord|
            ai.minimax(game_state.make_move(coord))
          end
          lowest_score = child_state_scores.min

          expect(ai.minimax(game_state)).to eq lowest_score
        end
      end
    end
  end
end