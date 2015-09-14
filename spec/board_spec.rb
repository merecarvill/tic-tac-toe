require 'spec_helper'

module TicTacToe
  describe Board do
    include_context 'default_values'
    include_context 'helper_methods'

    let(:board_error) { Board::BoardError }

    describe '.blank_mark' do
      it 'returns the mark used by board to indicate a blank cell' do
        board = new_board(@default_board_size)

        board.all_coordinates.each do |coordinates|
          expect(board.read_cell(*coordinates)).to eq Board.blank_mark
        end
      end
    end

    describe '#initialize' do
      it 'takes a parameters hash' do
        expect { described_class.new(size: @default_board_size) }.not_to raise_error
      end

      it 'raises error if given size is less than 3' do
        error_info = [board_error, 'Given size is too small, must be 3 or greater']

        expect { described_class.new(size: 2) }.to raise_error(*error_info)
      end

      context 'given the configuration of a board with preexisting marks' do
        let(:config) do
          _ = described_class.blank_mark
          x, o = :x, :o

          [ x, _, _,
            _, o, _,
            _, _, x ]
        end

        it 'generates a board with the specified marks in each cell' do
          board = described_class.new(size: @default_board_size, config: config)

          board.all_coordinates.zip(config).each do |coordinates, mark|
            expect(board.read_cell(*coordinates)).to eq mark
          end
        end

        it 'raises error if given configuration does not reconcile with given size' do
          error_info = [board_error, 'Given size does not reconcile with given configuration']
          params = {
            size: Math.sqrt(config.size).to_i + 1,
            config: config
          }

          expect { described_class.new(params) }.to raise_error(*error_info)
        end
      end

      context 'when not given a configuration of a board with preexisting marks' do
        it 'generates a NxN board of the given size' do
          (3..5).each do |size|
            custom_board = described_class.new(size: size)

            expect(custom_board.size).to eq size
            expect(custom_board.all_coordinates.count).to eq size**2
          end
        end

        it 'leaves the generated board blank' do
          expect(described_class.new(size: @default_board_size).all_blank?).to be true
        end
      end
    end

    describe '#read_cell' do
      it 'gets the contents of cell at given row and column' do
        mark = @default_player_marks.sample
        config = blank_board_configuration(@default_board_size)
        config[0] = mark
        board = described_class.new(size: @default_board_size, config: config)

        expect(board.read_cell(0, 0)).to eq mark
      end

      it 'raises error if cell coordinates are out of bounds' do
        error_info = [board_error, 'Cell coordinates are out of bounds']
        board = new_board(@default_board_size)

        expect { board.read_cell(board.size, board.size) }.to raise_error(*error_info)
      end
    end

    describe '#mark_cell' do
      let(:board) { new_board(@default_board_size) }
      let(:coordinates) { random_coordinates(board.size) }
      let(:mark) { @default_player_marks.sample }

      it 'sets the contents of an empty cell at the given row and column' do
        board.mark_cell(mark, *coordinates)

        expect(board.read_cell(*coordinates)).to eq mark
      end

      it 'records the coordinates of the last mark made' do
        board.mark_cell(mark, *coordinates)

        expect(board.last_move_made).to eq coordinates
      end

      it 'raises error if cell coordinates are out of bounds' do
        error_info = [board_error, 'Cell coordinates are out of bounds']
        oob_coordinates = [board.size, board.size]

        expect { board.mark_cell(mark, *oob_coordinates)}.to raise_error(*error_info)
      end

      it 'raises error when attempting to change contents of non-empty cell' do
        error_info = [board_error, 'Cannot alter a marked cell']
        board.mark_cell(mark, *coordinates)

        expect { board.mark_cell(mark, *coordinates) }.to raise_error(*error_info)
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
          board.mark_cell(@default_player_marks.sample, index, index)
          marked_coordinates << [index, index]
        end
        unmarked_coordinates = board.all_coordinates - marked_coordinates

        expect(board.blank_cell_coordinates).to match_array(unmarked_coordinates)
      end

      it 'returns empty array when no cells are blank' do
        board.all_coordinates.each do |coordinates|
          board.mark_cell(@default_player_marks.sample, *coordinates)
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
          board.mark_cell(mark, *coordinates)

          expect(board.last_mark_made).to eq mark
        end
      end
    end

    describe '#deep_copy' do
      let(:board) { new_board(@default_board_size) }

      it 'returns a new board that is a deep copy of the original' do
        coordinates1 = random_coordinates(board.size)
        board.mark_cell(@default_player_marks.sample, *coordinates1)

        board_copy = board.deep_copy
        begin coordinates2 = random_coordinates(board.size) end until coordinates1 != coordinates2
        board.mark_cell(@default_player_marks.sample, *coordinates2)

        expect(board.read_cell(*coordinates1)).to eq board_copy.read_cell(*coordinates1)
        expect(board.read_cell(*coordinates2)).not_to eq board_copy.read_cell(*coordinates2)
      end
    end

    describe '#blank?' do
      it 'returns true if cell at given coordinates is blank' do
        blank_board = new_board(@default_board_size)
        coordinates = random_coordinates(blank_board.size)

        expect(blank_board.blank?(coordinates)).to be true
      end

      it 'returns false if cell at given coordinates is not blank' do
        board = new_board(@default_board_size)
        coordinates = random_coordinates(board.size)
        board.mark_cell(@default_player_marks.sample, *coordinates)

        expect(board.blank?(coordinates)).to be false
      end
    end

    describe '#marked?' do
      it 'returns true if cell at given coordinates has any player\'s mark' do
        board = new_board(@default_board_size)
        coordinates = random_coordinates(board.size)
        board.mark_cell(@default_player_marks.sample, *coordinates)

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

    describe '#all_blank?' do
      it 'returns true if no cell in board is marked' do
        blank_board = new_board(@default_board_size)

        expect(blank_board.all_blank?).to be true
      end

      it 'returns false if any cell in board is marked' do
        board = new_board(@default_board_size)
        board.mark_cell(@default_player_marks.sample, *random_coordinates(board.size))

        expect(board.all_blank?).to be false
      end
    end

    describe '#all_marked?' do
      it 'returns true if all cells in board are marked' do
        board = new_board(@default_board_size)
        board.all_coordinates.each do |coordinates|
          board.mark_cell(@default_player_marks.sample, *coordinates)
        end

        expect(board.all_marked?).to be true
      end

      it 'returns false if any cell in board is blank' do
        board = new_board(@default_board_size)
        coordinates = random_coordinates(board.size)
        board.mark_cell(@default_player_marks.sample, *coordinates)

        expect(board.all_marked?).to be false
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
  end
end
