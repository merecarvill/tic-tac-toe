require 'spec_helper'

describe TicTacToe::ComputerPlayer do
  shared_context "default_values"

  let(:blank_board) { TicTacToe::Board.new({size: BOARD_SIZE}) }
  let(:ai_as_x) { described_class.new({mark: :x, board: blank_board}) }

  it 'implements PlayerInterface' do
    TicTacToe::PlayerInterface.required_methods.each do |method|
      expect(ai_as_x).to respond_to(method)
    end
  end

  describe '#initialize' do

    it 'takes a perameters hash with the player\'s mark and a reference to the game board' do
      mark = PLAYER_MARKS.shuffle
      ai = described_class.new({mark: mark, board: blank_board})

      expect(ai.mark).to eq mark
    end
  end
end