require "rspec"
require "rspec/collection_matchers"

RSpec.shared_context "default_values" do
  before :all do
    @default_board_size = 3
    @default_first_player = :x
    @default_second_player = :o
    @default_player_marks = [:x, :o]
    @default_player_types = [
      TicTacToe::AvailablePlayerTypes::HUMAN,
      TicTacToe::AvailablePlayerTypes::COMPUTER
    ]
  end
end

RSpec.shared_context "helper_methods" do
  def blank_board_configuration(board_size)
    (0...board_size**2).map { TicTacToe::Board.blank_mark }
  end

  def at_least_one_repeated_line?(string)
    lines = string.split("\n")
    lines.uniq.length < lines.length
  end

  def random_coordinates(board_size)
    [rand(board_size), rand(board_size)]
  end

  def new_board(parameters)
    TicTacToe::Board.new(parameters)
  end

  def build_board(config)
    size = Math.sqrt(config.size).to_i
    new_board(size: size, config: config)
  end

  def blank_board(board_size)
    new_board(size: board_size)
  end

  def board_with_draw(board_size, player_marks)
    first_mark, second_mark = player_marks
    blank_board(board_size).blank_cell_coordinates.reduce(blank_board(board_size)) do |board, (row, col)|
        if row == 0
          mark = col.odd? ? first_mark : second_mark
          board.mark_cell(mark, row, col)
        else
          mark = col.even? ? first_mark : second_mark
          board.mark_cell(mark, row, col)
        end
    end
  end
end
