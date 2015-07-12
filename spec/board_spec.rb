require 'spec_helper'

describe TicTacToe::Board do
  include_context "default_values"
  let(:default_perameters) { {size: BOARD_SIZE} }
  let(:board) {described_class.new(default_perameters)}

  describe '#initialize' do

    it 'takes a perameters hash' do
      expect{described_class.new(default_perameters)}.not_to raise_error
    end

    it 'generates a NxN board of the given size' do
      (1..3).each do |size|
        perameters = {size: size}
        custom_board = described_class.new(perameters)

        expect(custom_board.size).to eq size
        expect(custom_board.num_cells).to eq size**2
      end
    end

    it 'leaves the generated board blank' do
      expect(described_class.new(default_perameters).blank?).to be true
    end
  end

  describe '#[]=' do

    it 'sets the contents of an empty cell at the given row and column' do
      board[0,0] = :x
      expect(board.blank?).to be false
    end

    it 'raises error when attempting to change contents of non-empty cell' do
      board[0,0] = :x
      expect{board[0,0] = :o}.to raise_error('Cannot alter marked cell')
    end
  end

  describe '#[]' do

    it 'gets the contents of cell at given row and column' do
      expect(board[0,0]).to be nil
      board[0,0] = :x
      expect(board[0,0]).to eq :x
    end

    it 'raises error if cell coordinates are out of bounds' do
      expect{board[board.size, board.size]}.to raise_error('Cell coordinates are out of bounds')
    end
  end
end