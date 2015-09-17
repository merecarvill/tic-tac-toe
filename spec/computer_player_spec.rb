require "spec_helper"

module TicTacToe
  describe ComputerPlayer do
    include_context "default_values"
    include_context "helper_methods"

    let(:ai) do
      described_class.new(
        board: blank_board(@default_board_size),
        player_mark: @default_first_player,
        opponent_mark: @default_second_player)
    end
    let(:infinity) { Float::INFINITY }
    let(:neg_infinity) { -Float::INFINITY }

    describe "#initialize" do
      it "takes a parameters hash with the player's mark, opponent's mark, and the game board" do
        params = {
          board: blank_board(@default_board_size),
          player_mark: @default_first_player,
          opponent_mark: @default_second_player
        }

        expect { described_class.new(params) }.not_to raise_error
      end
    end

    describe "#move" do
      context "when a center space is available" do
        it "returns the move coordinate for centermost space" do
          [3, 5, 7].each do |odd_size|
            custom_ai = described_class.new(
              board: blank_board(odd_size),
              player_mark: @default_first_player,
              opponent_mark: @default_second_player)

            expect(custom_ai.move).to eq [odd_size / 2, odd_size / 2]
          end
        end
      end

      context "when a center space is not available" do
        let(:_) { Board.blank_mark }
        let(:x) { @default_first_player }
        let(:o) { @default_second_player }

        def first_player(board)
          parameters = {
            board: board,
            player_mark: x,
            opponent_mark: o
          }
          ComputerPlayer.new(parameters)
        end

        def second_player(board)
          parameters = {
            board: board,
            player_mark: o,
            opponent_mark: x
          }
          ComputerPlayer.new(parameters)
        end

        context "when computer player can make a horizontal winning move" do
          it "returns the coordinates of the winning move" do
            board_configs = [
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
            board_configs.zip(winning_moves).each do |board_config, winning_move|
              board = build_board(board_config)
              computer_player = first_player(board)

              expect(computer_player.move).to eq winning_move
            end
          end
        end

        context "when computer player can make a vertical winning move" do
          it "returns the coordinates of the winning move" do
            board_configs = [
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
            board_configs.zip(winning_moves).each do |board_config, winning_move|
              board = build_board(board_config)
              computer_player = first_player(board)

              expect(computer_player.move).to eq winning_move
            end
          end
        end

        context "when computer player can make a diagonal winning move" do
          it "returns the coordinates of the winning move" do
            board_configs = [
              [ x, _, o,
                o, x, _,
                x, o, _ ],
              [ o, x, _,
                o, x, _,
                x, o, _ ]
            ]
            winning_moves = [[2, 2], [0, 2]]
            board_configs.zip(winning_moves).each do |board_config, winning_move|
              board = build_board(board_config)
              computer_player = first_player(board)

              expect(computer_player.move).to eq winning_move
            end
          end
        end

        context "when opponent can make a horizontal winning move next turn" do
          it "returns the coordinates of the move that blocks the opponent from winning" do
            board_configs = [
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
            board_configs.zip(winning_moves).each do |board_config, winning_move|
              board = build_board(board_config)
              computer_player = second_player(board)

              expect(computer_player.move).to eq winning_move
            end
          end
        end

        context "when opponent can make a vertical winning move next turn" do
          it "returns the coordinates of the move that blocks the opponent from winning" do
            board_configs = [
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
            board_configs.zip(winning_moves).each do |board_config, winning_move|
              board = build_board(board_config)
              computer_player = second_player(board)

              expect(computer_player.move).to eq winning_move
            end
          end
        end

        context "when opponent can make a diagonal winning move next turn" do
          it "returns the coordinates of the move that blocks the opponent from winning" do
            board_configs = [
              [ x, _, o,
                o, x, _,
                x, o, _ ],
              [ o, x, _,
                o, x, _,
                x, o, _ ]
            ]
            winning_moves = [[2, 2], [0, 2]]
            board_configs.zip(winning_moves).each do |board_config, winning_move|
              board = build_board(board_config)
              computer_player = second_player(board)

              expect(computer_player.move).to eq winning_move
            end
          end
        end
      end
    end
  end
end
