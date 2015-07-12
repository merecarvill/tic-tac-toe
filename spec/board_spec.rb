require 'spec_helper'

describe TicTacToe::Board do
  include_context "default_values"
  include_context "error_messages"
  include_context "helper_methods"

  let(:board_error) { TicTacToe::Board::BoardError }
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
      row, col = random_coordinate(board.size)
      prior_contents = board[row,col]
      board[row, col] = :x

      expect(board[row,col]).not_to eq prior_contents
    end

    it 'raises error when attempting to change contents of non-empty cell' do
      row, col = random_coordinate(board.size)
      board[row, col] = :x

      expect{board[row, col] = :o}.to raise_error(board_error, NON_EMPTY_CELL_ERROR_MSG)
    end
  end

  describe '#[]' do

    it 'gets the contents of cell at given row and column' do
      row, col = random_coordinate(board.size)
      board[row, col] = :x

      expect(board[row, col]).to eq :x
    end

    it 'raises error if cell coordinates are out of bounds' do
      expect{board[board.size, board.size]}.to raise_error(board_error, OUT_OF_BOUNDS_ERROR_MSG)
    end
  end

  describe '#intersecting_lines' do

    it 'returns all lines that include the cell at given row and col' do
      all_coordinates(board.size).each do |coordinate|
        row, col = coordinate
        lines = board.intersecting_lines(row, col)

        lines.each do |line|
          expect(line[:cells].count).to eq board.size
        end
        expect(lines.any?{ |line| line[:row] == row }).to be true
        expect(lines.any?{ |line| line[:col] == col }).to be true
        expect(lines.any?{ |line| line.has_key?(:left_diag) }).to eq row == col
        expect(lines.any?{ |line| line.has_key?(:right_diag) }).to eq row + col == board.size - 1
      end
    end

    it 'raises error if cell coordinates are out of bounds' do
      expect{board.intersecting_lines(board.size, board.size)}.to raise_error(board_error, OUT_OF_BOUNDS_ERROR_MSG)
    end
  end

  describe '#marked?' do

    it 'checks if cell at given row and col has any player\'s mark' do
      row, col = random_coordinate(board.size)

      expect(board.marked?(row, col)).to be false
      board[row, col] = :x
      expect(board.marked?(row, col)).to be true
    end
  end

  describe '#blank?' do

    it 'checks if no cell in board is marked' do
      marked_cell = false
      all_coordinates(board.size).each do |coordinate|
        row, col = coordinate
        marked_cell ||= board.marked?(row, col)
      end

      expect(board.blank?).not_to eq marked_cell

      row, col = random_coordinate(board.size)
      board[row, col] = :x

      expect(board.blank?).to be false
    end
  end
end