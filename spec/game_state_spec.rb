require 'spec_helper'

describe TicTacToe::GameState do
  include_context "helper_methods"

  let(:board) { TicTacToe::Board.new({size: BOARD_SIZE, other_board: nil}) }

  describe '#initialize' do

    it 'takes a parameters hash with a game board, current player\'s mark, and opponent\'s mark' do
      player_mark, opponent_mark = PLAYER_MARKS.shuffle
      params = {board: board, player: player_mark, opponent: opponent_mark}

      expect{described_class.new(params)}.not_to raise_error
    end
  end

  describe '#score' do

    it 'exposes an attribute for recording the result of evaluation by a minimax function' do
      player_mark, opponent_mark = PLAYER_MARKS.shuffle
      params = {board: board, player: player_mark, opponent: opponent_mark}
      game_state = described_class.new(params)
      game_state.rank = 1

      expect(game_state.rank).to eq 1
    end
  end

  describe '#make_move' do

    context 'when board is blank at given coordinate' do

      it 'returns a new game state object' do
        player_mark, opponent_mark = PLAYER_MARKS.shuffle
        params = {board: board, player: player_mark, opponent: opponent_mark}
        initial_game_state = described_class.new(params)
        new_game_state = initial_game_state.make_move(random_coordinate(board.size))

        expect(new_game_state).not_to eq initial_game_state
      end

      it 'creates a new board object to associate with the new game state' do
        player_mark, opponent_mark = PLAYER_MARKS.shuffle
        params = {board: board, player: player_mark, opponent: opponent_mark}
        initial_game_state = described_class.new(params)
        new_game_state = initial_game_state.make_move(random_coordinate(board.size))

        expect(new_game_state.board).not_to eq initial_game_state.board
      end

      it 'marks the new game state board with player\'s mark at given coordinate' do
        player_mark, opponent_mark = PLAYER_MARKS.shuffle
        params = {board: board, player: player_mark, opponent: opponent_mark}
        initial_game_state = described_class.new(params)
        coordinate = random_coordinate(board.size)
        new_game_state = initial_game_state.make_move(coordinate)

        expect(new_game_state.board[*coordinate]).to eq player_mark
      end

      it 'remembers the last move made in the new game state' do
        player_mark, opponent_mark = PLAYER_MARKS.shuffle
        params = {board: board, player: player_mark, opponent: opponent_mark}
        initial_game_state = described_class.new(params)
        coordinate = random_coordinate(board.size)
        new_game_state = initial_game_state.make_move(coordinate)

        expect(new_game_state.last_move).to eq coordinate
        expect(initial_game_state.last_move).not_to eq coordinate
      end
    end
  end
end