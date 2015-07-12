require 'rspec'
require_relative '../lib/board'

RSpec.shared_context "default_values" do
  BOARD_SIZE = 3
end

RSpec.shared_context "helper_methods" do
  def random_coordinate(board_size)
    [rand(board_size), rand(board_size)]
  end
end