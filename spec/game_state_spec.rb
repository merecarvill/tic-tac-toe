require 'spec_helper'

describe TicTacToe::GameState do
  include_context "helper_methods"

  let(:blank_board) { TicTacToe::Board.new(size: BOARD_SIZE) }
  let(:game_start_state) {
    described_class.new(
      board: blank_board,
      current_player: PLAYER_MARKS[0],
      opponent: PLAYER_MARKS[1])
  }

  describe '#initialize' do

    it 'takes a parameters hash with a game board, current player\'s mark, and opponent\'s mark' do
      params = {board: blank_board, current_player: :x, opponent: :o}

      expect{ described_class.new(params) }.not_to raise_error
    end
  end

  describe '#score' do

    it 'exposes an attribute for recording the result of evaluation by a minimax function' do
      game_state = game_start_state
      game_state.rank = 1

      expect(game_state.rank).to eq 1
    end
  end

  describe '#make_move' do

    context 'when board is blank at given coordinate' do

      it 'returns a new game state object' do
        modified_game_state = game_start_state.make_move(random_coordinate(blank_board.size))

        expect(modified_game_state).not_to eq game_start_state
      end

      it 'creates a new board object to associate with the new game state' do
        modified_game_state = game_start_state.make_move(random_coordinate(blank_board.size))

        expect(modified_game_state.board).not_to eq game_start_state.board
      end

      it 'marks the new game state board with player\'s mark at given coordinate' do
        coordinate = random_coordinate(blank_board.size)
        modified_game_state = game_start_state.make_move(coordinate)

        expect(modified_game_state.board[*coordinate]).to eq game_start_state.player_mark
      end

      it 'remembers the last move made in the new game state' do
        coordinate = random_coordinate(blank_board.size)
        modified_game_state = game_start_state.make_move(coordinate)

        expect(modified_game_state.last_move).to eq coordinate
        expect(game_start_state.last_move).not_to eq coordinate
      end
    end
  end
end