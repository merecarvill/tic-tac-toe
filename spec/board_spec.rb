require 'spec_helper'

describe TicTacToe::Board do
  include_context "default_values"
  include_context "error_messages"
  include_context "helper_methods"

  describe '#initialize' do

    it 'takes a perameters hash' do
      expect{ described_class.new(size: @default_board_size, board: nil) }.not_to raise_error
    end

    context 'when NOT given another board to copy' do

      it 'generates a NxN board of the given size' do
        (1..3).each do |size|
          custom_board = described_class.new(size: size)

          expect(custom_board.size).to eq size
          expect(custom_board.num_cells).to eq size**2
        end
      end

      it 'leaves the generated board blank' do
        expect(described_class.new(size: @default_board_size).blank?).to be true
      end
    end

    context 'when given another board to copy' do

      it 'copies the cell values to a new board in the same configuration' do
        board = new_board(@default_board_size)
        all_coordinates(board.size).each do |coordinate|
          board[*coordinate] = @default_player_marks.sample
        end
        board_copy = described_class.new(size: board.size, board: board)

        all_coordinates(board.size).each do |coordinate|
          expect(board_copy[*coordinate]).to eq board[*coordinate]
        end
      end

      it 'deep copies the cells' do
        board = new_board(@default_board_size)
        board_copy = described_class.new(size: board.size, board: board)
        coordinate = random_coordinate(board.size)
        board[*coordinate] = @default_player_marks.sample

        expect(board[*coordinate]).not_to eq board_copy[*coordinate]
      end

      it 'raises error if given board is not the right size' do
        small_board = described_class.new(size: @default_board_size - 1)

        params = {size: @default_board_size, board: small_board}
        error_info = @incorrect_board_size_error_info

        expect{ described_class.new(params) }.to raise_error(*error_info)
      end
    end
  end

  describe '#[]=' do

    it 'sets the contents of an empty cell at the given row and column' do
      board = new_board(@default_board_size)
      coordinate = random_coordinate(board.size)
      mark = @default_player_marks.sample
      board[*coordinate] = mark

      expect(board[*coordinate]).to eq mark
    end

    it 'raises error if cell coordinates are out of bounds' do
      board = new_board(@default_board_size)

      error_info = @out_of_bounds_error_info

      expect{ board[board.size, board.size] = @default_player_marks.sample }.to raise_error(*error_info)
    end

    it 'raises error when attempting to change contents of non-empty cell' do
      board = new_board(@default_board_size)
      coordinate = random_coordinate(board.size)
      board[*coordinate] = @default_player_marks.sample

      error_info = @non_empty_cell_error_info

      expect{ board[*coordinate] = @default_player_marks.sample }.to raise_error(*error_info)
    end
  end

  describe '#[]' do

    it 'gets the contents of cell at given row and column' do
      board = new_board(@default_board_size)
      coordinate = random_coordinate(board.size)
      mark = @default_player_marks.sample
      board[*coordinate] = mark

      expect(board[*coordinate]).to eq mark
    end

    it 'raises error if cell coordinates are out of bounds' do
      board = new_board(@default_board_size)

      error_info = @out_of_bounds_error_info

      expect{ board[board.size, board.size] }.to raise_error(*error_info)
    end
  end

  describe '#lines' do

    it 'returns the contents of every board-length line (rows, cols, and diagonals)' do
      board = new_board(@default_board_size)
      lines = board.lines

      lines.each do |line|
        expect(line.count).to eq board.size
      end
      expect(lines.count).to eq board.size*2 + 2
    end
  end

  describe '#blank_cell_coordinates' do

    it 'returns all cell coordinates when board is blank' do
      blank_board = new_board(@default_board_size)
      expect(blank_board.blank_cell_coordinates).to match_array(all_coordinates(blank_board.size))
    end

    it 'returns the coordinates of all blank cells in board' do
      board = new_board(@default_board_size)
      marked_coordinates = []
      board.size.times do |index|
        board[index, index] = @default_player_marks.sample
        marked_coordinates << [index, index]
      end
      unmarked_coordinates = all_coordinates(board.size) - marked_coordinates

      expect(board.blank_cell_coordinates).to match_array(unmarked_coordinates)
    end

    it 'returns empty array when no cells are blank' do
      board = new_board(@default_board_size)
      all_coordinates(board.size).each do |coordinate|
        board[*coordinate] = @default_player_marks.sample
      end

      expect(board.blank_cell_coordinates).to eq []
    end
  end

  describe '#deep_copy' do

    it 'returns a new board that is a deep copy of the original' do
      board = new_board(@default_board_size)
      coordinate1 = random_coordinate(board.size)
      board[*coordinate1] = @default_player_marks.sample

      board_copy = board.deep_copy
      begin coordinate2 = random_coordinate(board.size) end until coordinate1 != coordinate2
      board[*coordinate2] = @default_player_marks.sample

      expect(board[*coordinate1]).to eq board_copy[*coordinate1]
      expect(board[*coordinate2]).not_to eq board_copy[*coordinate2]
    end
  end

  describe '#marked?' do

    it 'checks if cell at given row and col has any player\'s mark' do
      blank_board = new_board(@default_board_size)
      board = blank_board.deep_copy
      coordinate = random_coordinate(board.size)
      board[*coordinate] = @default_player_marks.sample

      expect(blank_board.marked?(*coordinate)).to be false
      expect(board.marked?(*coordinate)).to be true
    end
  end

  describe '#blank?' do

    it 'checks if no cell in board is marked' do
      blank_board = new_board(@default_board_size)
      board = blank_board.deep_copy
      coordinate = random_coordinate(board.size)
      board[*coordinate] = @default_player_marks.sample

      expect(blank_board.blank?).to be true
      expect(board.blank?).to be false
    end
  end

  describe '#filled?' do

    it 'checks if all cells in board are marked' do
      blank_board = new_board(@default_board_size)
      board = blank_board.deep_copy
      all_coordinates(board.size).each do |coordinate|
        board[*coordinate] = @default_player_marks.sample
      end

      expect(blank_board.filled?).to be false
      expect(board.filled?).to be true
    end
  end

  describe '#has_winning_line?' do

    it 'checks if board has any winning lines' do
      blank_board = new_board(@default_board_size)
      mark = @default_player_marks.sample

      expect(blank_board.has_winning_line?).to be false
      all_wins(@default_board_size, mark).each do |won_board|
        expect(won_board.has_winning_line?).to be true
      end
    end
  end
end