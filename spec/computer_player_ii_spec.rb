require "spec_helper"

module TicTacToe
  describe ComputerPlayerII do
    include_context "default_values"
    include_context "helper_methods"

    def new_computer_player(parameters)
      ComputerPlayerII.new(parameters)
    end

    let(:_) { Board.blank_mark }
    let(:x) { @default_first_player }
    let(:o) { @default_second_player }

    describe "#move" do
      it "returns the coordinates of a valid move" do
        board_config = [
          x, o, x,
          o, x, o,
          x, o, _
        ]
        board = build_board(board_config.shuffle)
        parameters = {
          board: board,
          player_mark: x,
          opponent_mark: o
        }
        computer_player = new_computer_player(parameters)
        coordinates = computer_player.move

        expect(board.out_of_bounds?(coordinates)).to be false
        expect(board.blank?(coordinates)).to be true
      end

      context "when game board has a center space and it is blank" do
        it "returns the center coordinates" do
          board_size = @default_board_size.odd? ? @default_board_size : 3
          parameters = {
            board: blank_board(board_size),
            player_mark: x,
            opponent_mark: o
          }
          computer_player = new_computer_player(parameters)

          expect(computer_player.move).to eq [board_size / 2, board_size / 2]
        end
      end
    end
  end
end