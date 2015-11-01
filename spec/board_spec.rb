require "spec_helper"
require "board"

module TicTacToe
  describe Board do
    include_context "default_values"
    include_context "helper_methods"

    let(:_) { Board::BLANK_MARK }
    let(:x) { @default_player_marks.first }
    let(:o) { @default_player_marks.last }

    describe "#initialize" do
      context "given a set of preexisting marks" do
        let(:marked_spaces) do
          [ x, _, _,
            _, o, _,
            _, _, x ]
        end

        it "generates a board with the specified marks in each space" do
          board = build_board(marked_spaces)

          board.all_coordinates.zip(marked_spaces).each do |coordinates, mark|
            expect(board.read_space(coordinates)).to eq mark
          end
        end
      end

      context "when not given a a set of preexisting marks" do
        it "generates a NxN board of the given size" do
          (3..5).each do |size|
            custom_board = blank_board(size)

            expect(custom_board.size).to eq size
            expect(custom_board.all_coordinates.count).to eq size**2
          end
        end

        it "leaves the generated board blank" do
          expect(blank_board(@default_board_size).all_blank?).to be true
        end
      end
    end

    describe "#read_space" do
      it "gets the contents of space at given row and column" do
        marked_spaces = [x, _, _, _, _, _, _, _, _]
        board = build_board(marked_spaces)

        expect(board.read_space([0, 0])).to eq x
      end
    end

    describe "#mark_space" do
      let(:board) { blank_board(@default_board_size) }
      let(:coordinates) { random_coordinates(board.size) }
      let(:mark) { @default_player_marks.sample }

      it "returns a new board with the given coordinates played" do
        board = blank_board(@default_board_size)

        expect(board.mark_space(mark, coordinates).read_space(coordinates)).to eq(mark)
      end

      it "does not mutate the board" do
        board = blank_board(@default_board_size)

        board.mark_space(mark, coordinates)

        expect(board).to be_all_blank
      end

      it "records the coordinates of the last mark made" do
        returned_board = board.mark_space(mark, coordinates)

        expect(returned_board.last_move_made).to eq coordinates
      end
    end

    describe "#lines" do
      let(:board) { blank_board(@default_board_size) }

      it "returns the contents of every board-length line (rows, cols, and diagonals)" do
        lines = board.lines

        lines.each do |line|
          expect(line.count).to eq board.size
        end
        expect(lines.count).to eq board.size * 2 + 2
      end
    end

    describe "#all_coordinates" do
      let(:board) { blank_board(@default_board_size) }

      it "returns the coordinates of every space in board" do
        all_coordinates = (0...board.size).to_a.repeated_permutation(2).to_a

        expect(board.all_coordinates).to match_array all_coordinates
      end
    end

    describe "#blank_space_coordinates" do
      it "returns all space coordinates when board is blank" do
        board = blank_board(@default_board_size)

        expect(board.blank_space_coordinates).to match_array board.all_coordinates
      end

      it "returns the coordinates of all blank spaces in board" do
        marked_spaces = [x, o, _, _, _, _, _, _, _].shuffle
        board = build_board(marked_spaces)
        unmarked_coordinates = board.all_coordinates.reject { |coords| board.marked?(coords) }

        expect(board.blank_space_coordinates).to match_array unmarked_coordinates
      end

      it "returns no coordinates when no spaces are blank" do
        marked_spaces = [x, o, x, o, x, o, x, o, x].shuffle
        board = build_board(marked_spaces)

        expect(board.blank_space_coordinates.count).to eq 0
      end
    end

    describe "#last_mark_made" do
      context "when board is blank" do
        it "returns nil" do
          expect(blank_board(@default_board_size).last_mark_made).to be nil
        end
      end

      context "when board is not blank" do
        it "returns the last mark made on the board" do
          board = blank_board(@default_board_size)
          mark = @default_player_marks.sample
          returned_board = board.mark_space(mark, random_coordinates(board.size))

          expect(returned_board.last_mark_made).to eq mark
        end
      end
    end

    describe "#blank?" do
      it "returns true if space at given coordinates is blank" do
        board = blank_board(@default_board_size)

        expect(board.blank?(random_coordinates(board.size))).to be true
      end

      it "returns false if space at given coordinates is not blank" do
        board = blank_board(@default_board_size)
        coordinates = random_coordinates(board.size)
        returned_board = board.mark_space(@default_player_marks.sample, coordinates)

        expect(returned_board.blank?(coordinates)).to be false
      end
    end

    describe "#marked?" do
      it "returns true if space at given coordinates has any player's mark" do
        board = blank_board(@default_board_size)
        coordinates = random_coordinates(board.size)
        returned_board = board.mark_space(@default_player_marks.sample, coordinates)

        expect(returned_board.marked?(coordinates)).to be true
      end

      it "returns false if space at given coordinates does not have a player's mark" do
        blank_board = blank_board(@default_board_size)
        coordinates = random_coordinates(blank_board.size)

        expect(blank_board.marked?(coordinates)).to be false
      end
    end

    describe "#out_of_bounds?" do
      it "returns true if given coordinates are not within bounds of board" do
        board = blank_board(@default_board_size)
        coordinates = [0, board.size]

        expect(board.out_of_bounds?(coordinates)).to be true
      end

      it "returns false if given coordinates are within bounds of board" do
        board = blank_board(@default_board_size)

        board.all_coordinates.each do |coordinates|
          expect(board.out_of_bounds?(coordinates)).to be false
        end
      end
    end

    describe "#all_blank?" do
      it "returns true if no space in board is marked" do
        board = blank_board(@default_board_size)

        expect(board.all_blank?).to be true
      end

      it "returns false if any space in board is marked" do
        marked_spaces = [x, _, _, _, _, _, _, _, _].shuffle
        board = build_board(marked_spaces)

        expect(board.all_blank?).to be false
      end
    end

    describe "#all_marked?" do
      it "returns true if all spaces in board are marked" do
        marked_spaces = [x, x, x, x, x, o, o, o, o].shuffle
        board = build_board(marked_spaces)

        expect(board.all_marked?).to be true
      end

      it "returns false if any space in board is blank" do
        marked_spaces = [x, x, x, x, _, o, o, o, o].shuffle
        board = build_board(marked_spaces)

        expect(board.all_marked?).to be false
      end
    end

    describe "#has_winning_line?" do
      it "returns true if board has a horizontal winning line" do
        winning_configurations = [
          [ x, x, x,
            _, _, _,
            _, _, _ ],
          [ _, _, _,
            x, x, x,
            _, _, _ ],
          [ _, _, _,
            _, _, _,
            x, x, x ]
        ]

        winning_configurations.each do |marked_spaces|
          expect(build_board(marked_spaces).has_winning_line?).to be true
        end
      end

      it "returns true if board has a vertical winning line" do
        winning_configurations = [
          [ x, _, _,
            x, _, _,
            x, _, _ ],
          [ _, x, _,
            _, x, _,
            _, x, _ ],
          [ _, _, x,
            _, _, x,
            _, _, x ]
        ]

        winning_configurations.each do |marked_spaces|
          expect(build_board(marked_spaces).has_winning_line?).to be true
        end
      end

      it "returns true if board has a diagonal winning line" do
        winning_configurations = [
          [ x, _, _,
            _, x, _,
            _, _, x ],
          [ _, _, x,
            _, x, _,
            x, _, _ ]
        ]

        winning_configurations.each do |marked_spaces|
          expect(build_board(marked_spaces).has_winning_line?).to be true
        end
      end

      it "returns false if board has no winning line" do
        non_winning_configurations = [
          [ _, _, _,
            _, _, _,
            _, _, _ ],
          [ _, _, _,
            x, x, o,
            _, _, _ ],
          [ x, _, _,
            x, _, _,
            o, _, _ ],
          [ x, _, _,
            _, x, _,
            _, _, o ],
          [ x, o, x,
            x, o, x,
            o, x, o ]
        ]

        non_winning_configurations.each do |marked_spaces|
          expect(build_board(marked_spaces).has_winning_line?).to be false
        end
      end
    end
  end
end
