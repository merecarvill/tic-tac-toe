require "spec_helper"
require "computer_player"

require "board"
require "game"

module TicTacToe
  describe ComputerPlayer do
    include_context "default_values"
    include_context "helper_methods"

    let(:_) { Board::BLANK_MARK }
    let(:x) { @default_first_player }
    let(:o) { @default_second_player }

    def new_computer_player(parameters)
      ComputerPlayer.new(parameters)
    end

    def x_player(board)
      parameters = {
        board: board,
        player_mark: x,
        opponent_mark: o
      }
      new_computer_player(parameters)
    end

    def o_player(board)
      parameters = {
        board: board,
        player_mark: o,
        opponent_mark: x
      }
      new_computer_player(parameters)
    end

    describe "#move" do
      it "returns the coordinates of a valid move" do
        marked_spaces = [
          x, o, x,
          x, x, o,
          o, _, _
        ]
        board = build_board(marked_spaces).mark_space(o, [2, 1])
        game = Game.new(board: board)
        computer_player = x_player(board)
        coordinates = computer_player.move(game)

        expect(board.out_of_bounds?(coordinates)).to be false
        expect(board.blank?(coordinates)).to be true
      end

      context "when game board has a center space and it is blank" do
        it "returns the center coordinates" do
          board_size = @default_board_size.odd? ? @default_board_size : 3
          game = Game.new(board: blank_board(board_size))

          computer_player = x_player(blank_board(board_size))

          expect(computer_player.move(game)).to eq [board_size / 2, board_size / 2]
        end
      end

      context "when computer player can make a horizontal winning move" do
        it "returns the coordinates of the winning move" do
          board_configurations = [
            [ x, _, x,
              _, o, _,
              o, x, o ],
            [ o, _, _,
              x, x, _,
              o, o, x ],
            [ _, o, _,
              x, o, o,
              _, x, x ]
          ]
          winning_moves = [[0, 1], [1, 2], [2, 0]]
          board_configurations.zip(winning_moves).each do |marked_spaces, winning_move|
            board = build_board(marked_spaces)
            game = Game.new(board: board)
            computer_player = x_player(board)

            expect(computer_player.move(game)).to eq winning_move
          end
        end
      end

      context "when computer player can make a vertical winning move" do
        it "returns the coordinates of the winning move" do
          board_configurations = [
            [ x, _, o,
              _, o, x,
              x, _, o ],
            [ o, x, o,
              o, x, _,
              x, _, _ ],
            [ _, o, _,
              _, o, x,
              o, x, x ]
          ]
          winning_moves = [[1, 0], [2, 1], [0, 2]]
          board_configurations.zip(winning_moves).each do |marked_spaces, winning_move|
            board = build_board(marked_spaces)
            game = Game.new(board: board)
            computer_player = x_player(board)

            expect(computer_player.move(game)).to eq winning_move
          end
        end
      end

      context "when computer player can make a diagonal winning move" do
        it "returns the coordinates of the winning move" do
          board_configurations = [
            [ x, _, o,
              o, x, _,
              x, o, _ ],
            [ o, x, _,
              o, x, _,
              x, o, _ ]
          ]
          winning_moves = [[2, 2], [0, 2]]
          board_configurations.zip(winning_moves).each do |marked_spaces, winning_move|
            board = build_board(marked_spaces)
            computer_player = x_player(board)
            game = Game.new(board: board)

            expect(computer_player.move(game)).to eq winning_move
          end
        end
      end

      context "when opponent can make a horizontal winning move next turn" do
        it "returns the coordinates of the move that blocks the opponent from winning" do
          board_configurations = [
            [ x, _, x,
              _, o, _,
              o, x, o ],
            [ o, _, _,
              x, x, _,
              o, o, x ],
            [ _, o, _,
              x, o, o,
              _, x, x ]
          ]
          winning_moves = [[0, 1], [1, 2], [2, 0]]
          board_configurations.zip(winning_moves).each do |marked_spaces, winning_move|
            board = build_board(marked_spaces)
            computer_player = o_player(board)
            game = Game.new(board: board)

            expect(computer_player.move(game)).to eq winning_move
          end
        end
      end

      context "when opponent can make a vertical winning move next turn" do
        it "returns the coordinates of the move that blocks the opponent from winning" do
          board_configurations = [
            [ x, _, o,
              _, o, x,
              x, _, o ],
            [ o, x, o,
              o, x, _,
              x, _, _ ],
            [ _, o, _,
              _, o, x,
              o, x, x ]
          ]
          winning_moves = [[1, 0], [2, 1], [0, 2]]
          board_configurations.zip(winning_moves).each do |marked_spaces, winning_move|
            board = build_board(marked_spaces)
            computer_player = o_player(board)
            game = Game.new(board: board)

            expect(computer_player.move(game)).to eq winning_move
          end
        end
      end

      context "when opponent can make a diagonal winning move next turn" do
        it "returns the coordinates of the move that blocks the opponent from winning" do
          board_configurations = [
            [ x, _, o,
              o, x, _,
              x, o, _ ],
            [ o, x, _,
              o, x, _,
              x, o, _ ]
          ]
          winning_moves = [[2, 2], [0, 2]]
          board_configurations.zip(winning_moves).each do |marked_spaces, winning_move|
            board = build_board(marked_spaces)
            computer_player = o_player(board)
            game = Game.new(board: board)

            expect(computer_player.move(game)).to eq winning_move
          end
        end
      end

      context "when opponent can make a fork next turn" do
        it "returns the coordinates of a move that prevents that fork" do
          board_configurations = [
            [ x, _, _,
              _, x, _,
              _, _, o ],
            [ x, _, _,
              _, o, _,
              _, _, x ],
            [ _, x, _,
              _, x, _,
              _, o, _ ]
          ]
          good_move_sets = [
            [[2, 0], [0, 2]],
            [[0, 1], [1, 0], [1, 2], [2, 1]],
            [[0, 0], [0, 2], [2, 0], [2, 2]]
          ]
          board_configurations.zip(good_move_sets).each do |marked_spaces, good_moves|
            board = build_board(marked_spaces)
            computer_player = o_player(board)
            game = Game.new(board: board)

            expect(good_moves).to include computer_player.move(game)
          end
        end
      end
    end
  end
end