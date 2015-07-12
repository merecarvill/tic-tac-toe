require 'rspec'
require_relative '../lib/board'
require_relative '../lib/player_interface'

RSpec.shared_context "default_values" do
  BOARD_SIZE = 3
end

RSpec.shared_context "error_messages" do
  OUT_OF_BOUNDS_ERROR_MSG = 'Cell coordinates are out of bounds'
  NON_EMPTY_CELL_ERROR_MSG = 'Cannot alter marked cell'
end

RSpec.shared_context "helper_methods" do
  def random_coordinate(board_size)
    [rand(board_size), rand(board_size)]
  end
end