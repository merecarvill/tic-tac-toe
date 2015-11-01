require "rspec"
require "rspec/collection_matchers"

RSpec.shared_context "default_values" do
  before :all do
    @default_board_size = 3
    @default_player_marks = [:x, :o]
    @default_player_types = [
      TicTacToe::AvailablePlayerTypes::HUMAN,
      TicTacToe::AvailablePlayerTypes::COMPUTER
    ]
  end
end

RSpec.shared_context "helper_methods" do
  def random_coordinates(board_size)
    [rand(board_size), rand(board_size)]
  end

  def build_board(marked_spaces)
    TicTacToe::Board.new(marked_spaces: marked_spaces)
  end

  def blank_board(board_size)
    TicTacToe::Board.new(size: board_size)
  end
end
