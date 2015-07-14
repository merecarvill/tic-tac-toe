require 'spec_helper'

describe TicTacToe::GameState do

  describe '#initialize' do

    it 'takes a parameters hash with a game board, current player\'s mark, and opponent\'s mark' do
      board = TicTacToe::Board.new({size: BOARD_SIZE, other_board: nil})
      player_mark, opponent_mark = PLAYER_MARKS.shuffle
      params = {board: board, player: player_mark, opponent: opponent_mark}

      expect{described_class.new(params)}.not_to raise_error
    end
  end
end