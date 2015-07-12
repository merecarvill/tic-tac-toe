require 'spec_helper'

describe TicTacToe::Board do

  describe '#initialize' do

    it 'takes a perameters hash' do
      perameters = {size: 3}

      expect{TicTacToe::Board.new(perameters)}.not_to raise_error
    end

    it 'generates a NxN board of the given size' do
      (1..3).each do |size|
        perameters = {size: size}
        board = TicTacToe::Board.new(perameters)

        expect(board.size).to eq size
        expect(board.num_cells).to eq size**2
      end
    end
  end
end