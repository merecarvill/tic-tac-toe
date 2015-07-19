require 'spec_helper'

describe TicTacToe::ComputerPlayer do
  include_context "helper_methods"
  include_context "default_values"

  # let(:blank_board) { TicTacToe::Board.new({size: @default_board_size}) }

  it 'implements PlayerInterface' do
    player_mark, opponent_mark = @default_player_marks.shuffle
    ai = described_class.new(board: new_board(@default_board_size), player: player_mark, opponent: opponent_mark)

    TicTacToe::PlayerInterface.required_methods.each do |method|
      expect(ai).to respond_to(method)
    end
  end

  describe '#initialize' do

    it 'takes a parameters hash with the player\'s mark, opponent\'s mark, and the game board' do
      player_mark, opponent_mark = @default_player_marks.shuffle
      params = {board: new_board(@default_board_size), player: player_mark, opponent: opponent_mark}

      expect{described_class.new(params)}.not_to raise_error
    end
  end

  describe '#minimax_score' do

    it 'returns 1 when given game state is a win for computer player' do
      player_mark, opponent_mark = @default_player_marks.shuffle
      ai = described_class.new(
        board: new_board(@default_board_size),
        player: player_mark,
        opponent: opponent_mark
      )

      all_wins(@default_board_size, player_mark).each do |winning_board|
        game_state = TicTacToe::GameState.new(
          board: winning_board,
          player: player_mark,
          opponent: opponent_mark
        )

        expect(ai.minimax_score(game_state)).to eq 1
      end
    end

    it 'returns -1 when given game state is a win for opponent' do
      player_mark, opponent_mark = @default_player_marks.shuffle
      ai = described_class.new(
        board: new_board(@default_board_size),
        player: player_mark,
        opponent: opponent_mark
      )

      all_wins(@default_board_size, opponent_mark).each do |winning_board|
        game_state = TicTacToe::GameState.new(
          board: winning_board,
          player: player_mark,
          opponent: opponent_mark
        )

        expect(ai.minimax_score(game_state)).to eq -1
      end
    end

    it 'returns 0 if game state is a draw' do
      player_mark, opponent_mark = @default_player_marks.shuffle
      ai = described_class.new(board: new_board(@default_board_size), player: player_mark, opponent: opponent_mark)

      board = new_board(@default_board_size)
      (0...@default_board_size).each do |row|
        (0...@default_board_size).each do |col|
          if row == 0
            board[row, col] = col.even? ? player_mark : opponent_mark
          else
            board[row, col] = col.odd? ? player_mark : opponent_mark
          end
        end
      end
      game_state = TicTacToe::GameState.new(board: board, player: player_mark, opponent: opponent_mark)

      expect(ai.minimax_score(game_state)).to eq 0
    end

    it 'returns nil if game state is unfinished' do
      board = new_board(@default_board_size)
      player_mark, opponent_mark = @default_player_marks.shuffle
      ai = described_class.new(board: board, player: player_mark, opponent: opponent_mark)
      game_state = TicTacToe::GameState.new(board: board, player: player_mark, opponent: opponent_mark)

      expect(ai.minimax_score(game_state)).to eq nil
    end
  end
end