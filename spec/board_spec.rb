require 'spec_helper'

describe TicTacToe::Board do
  include_context "default_values"

  describe '#initialize' do
    let(:default_perameters) { {size: BOARD_SIZE} }

    it 'takes a perameters hash' do
      expect{described_class.new(default_perameters)}.not_to raise_error
    end

    it 'generates a NxN board of the given size' do
      (1..3).each do |size|
        perameters = {size: size}
        board = described_class.new(perameters)

        expect(board.size).to eq size
        expect(board.num_cells).to eq size**2
      end
    end
  end
end