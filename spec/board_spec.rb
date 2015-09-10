require 'spec_helper'

module TicTacToe
  describe Board do
    include_context 'default_values'
    include_context 'helper_methods'

    let(:board_error) { Board::BoardError }

    describe '#initialize' do
      it 'takes a perameters hash' do
        expect { described_class.new(size: @default_board_size, board: nil) }.not_to raise_error
      end

      it 'raises error if given size is less than 3' do
        error_info = [board_error, 'Given size is too small, must be 3 or greater']

        expect { described_class.new(size: 2, board: nil) }.to raise_error(*error_info)
      end

      context 'when NOT given another board to copy' do
        it 'generates a NxN board of the given size' do
          (3..5).each do |size|
            custom_board = described_class.new(size: size)

            expect(custom_board.size).to eq size
            expect(custom_board.all_coordinates.count).to eq size**2
          end
        end

        it 'leaves the generated board blank' do
          expect(described_class.new(size: @default_board_size).blank?).to be true
        end
      end

      context 'when given another board to copy' do
        it 'copies the cell values to a new board in the same configuration' do
          board = board_with_draw(@default_board_size, @default_player_marks)
          board_copy = described_class.new(size: board.size, board: board)

          board.all_coordinates.each do |coordinates|
            expect(board_copy[*coordinates]).to eq board[*coordinates]
          end
        end

        it 'deep copies the cells' do
          board = new_board(@default_board_size)
          board_copy = described_class.new(size: board.size, board: board)
          coordinates = random_coordinates(board.size)
          board[*coordinates] = @default_player_marks.sample

          expect(board[*coordinates]).not_to eq board_copy[*coordinates]
        end

        it 'raises error if given board does not match given size' do
          large_board = described_class.new(size: @default_board_size + 1)

          params = { size: @default_board_size, board: large_board }
          error_info = [board_error, 'Given size does not match given board']

          expect { described_class.new(params) }.to raise_error(*error_info)
        end
      end
    end

    describe '#[]=' do
      let(:board) { new_board(@default_board_size) }
      let(:coordinates) { random_coordinates(board.size) }
      let(:mark) { mark = @default_player_marks.sample }

      it 'sets the contents of an empty cell at the given row and column' do
        board[*coordinates] = mark

        expect(board[*coordinates]).to eq mark
      end

      it 'records the coordinates of the last mark made' do
        board[*coordinates] = mark

        expect(board.last_move_made).to eq coordinates
      end

      it 'raises error if cell coordinates are out of bounds' do
        error_info = [board_error, 'Cell coordinates are out of bounds']

        expect { board[board.size, board.size] =  mark }.to raise_error(*error_info)
      end

      it 'raises error when attempting to change contents of non-empty cell' do
        board[*coordinates] = mark

        error_info = [board_error, 'Cannot alter marked cell']

        expect { board[*coordinates] = mark }.to raise_error(*error_info)
      end
    end

    describe '#[]' do
      let(:board) { new_board(@default_board_size) }
      let(:coordinates) { random_coordinates(board.size) }
      let(:mark) { mark = @default_player_marks.sample }

      it 'gets the contents of cell at given row and column' do
        board[*coordinates] = mark

        expect(board[*coordinates]).to eq mark
      end

      it 'raises error if cell coordinates are out of bounds' do
        error_info = [board_error, 'Cell coordinates are out of bounds']

        expect { board[board.size, board.size] }.to raise_error(*error_info)
      end
    end

    describe '#lines' do
      let(:board) { new_board(@default_board_size) }

      it 'returns the contents of every board-length line (rows, cols, and diagonals)' do
        lines = board.lines

        lines.each do |line|
          expect(line.count).to eq board.size
        end
        expect(lines.count).to eq board.size * 2 + 2
      end
    end

    describe '#all_coordinates' do
      let(:board) { new_board(@default_board_size) }

      it 'returns the coordinates of every cell in board' do
        expect(board.all_coordinates).to match_array (0...board.size).to_a.repeated_permutation(2).to_a
      end
    end

    describe '#blank_cell_coordinates' do
      let(:board) { new_board(@default_board_size) }

      it 'returns all cell coordinates when board is blank' do
        board = new_board(@default_board_size)

        expect(board.blank_cell_coordinates).to match_array(board.all_coordinates)
      end

      it 'returns the coordinates of all blank cells in board' do
        marked_coordinates = []
        board.size.times do |index|
          board[index, index] = @default_player_marks.sample
          marked_coordinates << [index, index]
        end
        unmarked_coordinates = board.all_coordinates - marked_coordinates

        expect(board.blank_cell_coordinates).to match_array(unmarked_coordinates)
      end

      it 'returns empty array when no cells are blank' do
        board.all_coordinates.each do |coordinates|
          board[*coordinates] = @default_player_marks.sample
        end

        expect(board.blank_cell_coordinates).to eq []
      end
    end

    describe '#last_mark_made' do
      let(:board) { new_board(@default_board_size) }
      let(:coordinates) { random_coordinates(board.size) }
      let(:mark) { mark = @default_player_marks.sample }

      context 'when board is blank' do
        it 'returns nil' do
          expect(board.last_mark_made).to be nil
        end
      end

      context 'when board is not blank' do
        it 'returns the last mark made on the board' do
          board[*coordinates] = mark

          expect(board.last_mark_made).to eq mark
        end
      end
    end

    describe '#deep_copy' do
      let(:board) { new_board(@default_board_size) }

      it 'returns a new board that is a deep copy of the original' do
        coordinate1 = random_coordinates(board.size)
        board[*coordinate1] = @default_player_marks.sample

        board_copy = board.deep_copy
        begin coordinate2 = random_coordinates(board.size) end until coordinate1 != coordinate2
        board[*coordinate2] = @default_player_marks.sample

        expect(board[*coordinate1]).to eq board_copy[*coordinate1]
        expect(board[*coordinate2]).not_to eq board_copy[*coordinate2]
      end
    end

    describe '#marked?' do
      it 'returns true if cell at given coordinates has any player\'s mark' do
        board = new_board(@default_board_size)
        coordinates = random_coordinates(board.size)
        board[*coordinates] = @default_player_marks.sample

        expect(board.marked?(coordinates)).to be true
      end

      it 'returns false if cell at given coordinates does not have a player\'s mark' do
        blank_board = new_board(@default_board_size)
        coordinates = random_coordinates(blank_board.size)

        expect(blank_board.marked?(coordinates)).to be false
      end
    end

    describe '#out_of_bounds?' do
      it 'returns true if given coordinates are not within bounds of board' do
        board = new_board(@default_board_size)
        coordinates = [0, board.size]

        expect(board.out_of_bounds?(coordinates)).to be true
      end

      it 'returns false if given coordinates are within bounds of board' do
        board = new_board(@default_board_size)

        board.all_coordinates.each do |coordinates|
          expect(board.out_of_bounds?(coordinates)).to be false
        end
      end
    end

    describe '#blank?' do
      it 'returns true if no cell in board is marked' do
        blank_board = new_board(@default_board_size)

        expect(blank_board.blank?).to be true
      end

      it 'returns false if any cell in board is marked' do
        board = new_board(@default_board_size)
        board[*random_coordinates(board.size)] = @default_player_marks.sample

        expect(board.blank?).to be false
      end
    end

    describe '#filled?' do
      it 'returns true if all cells in board are marked' do
        board = new_board(@default_board_size)
        board.all_coordinates.each do |coordinates|
          board[*coordinates] = @default_player_marks.sample
        end

        expect(board.filled?).to be true
      end

      it 'returns false if any cell in board is blank' do
        board = new_board(@default_board_size)
        coordinates = random_coordinates(board.size)
        board[*coordinates] = @default_player_marks.sample

        expect(board.filled?).to be false
      end
    end

    describe '#has_winning_line?' do
      it 'returns true if board has any winning lines' do
        mark = @default_player_marks.sample

        all_wins(@default_board_size, mark).each do |won_board|
          expect(won_board.has_winning_line?).to be true
        end
      end

      it 'returns false if board has no winning lines' do
        blank_board = new_board(@default_board_size)

        expect(blank_board.has_winning_line?).to be false
      end
    end

    describe '#game_over?' do
      it 'returns true if the game has ended in a draw' do
        board_with_draw = board_with_draw(@default_board_size, @default_player_marks)

        expect(board_with_draw.game_over?).to be true
      end

      it 'returns true if the game has been won' do
        all_wins(@default_board_size, @default_first_player).each do |board_with_win|

          expect(board_with_win.game_over?).to be true
        end
      end

      it 'returns false if board has no win and is not filled' do
        board = board_with_potential_win_loss_or_draw(@default_board_size, @default_player_marks)

        expect(board.game_over?).to be false
      end
    end
  end
end
