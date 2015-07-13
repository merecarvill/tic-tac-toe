require 'rspec'
require_relative '../lib/board'
require_relative '../lib/player_interface'
require_relative '../lib/computer_player'

RSpec.shared_context "default_values" do
  BOARD_SIZE = 3
  PLAYER_MARKS = [:x, :o]
end

RSpec.shared_context "error_messages" do
  OUT_OF_BOUNDS_ERROR_MSG = 'Cell coordinates are out of bounds'
  NON_EMPTY_CELL_ERROR_MSG = 'Cannot alter marked cell'
  INCORRECT_BOARD_SIZE_ERROR_MSG = 'Given board is incorrect size'
end

RSpec.shared_context "helper_methods" do
  def random_coordinate(board_size)
    [rand(board_size), rand(board_size)]
  end

  def all_coordinates(board_size)
    (0...board_size).to_a.repeated_permutation(2).to_a
  end
end