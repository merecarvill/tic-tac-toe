require "rspec"
require "rspec/collection_matchers"

RSpec.shared_context "default_values" do
  before :all do
    @default_board_size = 3
    @default_first_player = :x
    @default_second_player = :o
    @default_player_marks = [:x, :o]
    @default_player_types = [:human, :computer]
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

  def board_with_potential_win_loss_or_draw(board_size, player_marks)
    first_mark, second_mark = player_marks
    board = blank_board(board_size)
    (0...board_size - 1).each { |col| board.mark_cell(first_mark, 0, col) }
    (0...board_size - 1).each { |col| board.mark_cell(second_mark, 1, col) }
    (2...board_size).each do |row|
      (0...board_size - 1).each do |col|
        mark = col.even? ? first_mark : second_mark
        board.mark_cell(mark, row, col)
      end
    end
    board
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

  def all_wins(board_size, winning_mark)
    winning_boards = horizontal_wins(board_size, winning_mark)
    winning_boards.concat vertical_wins(board_size, winning_mark)
    winning_boards.concat diagonal_wins(board_size, winning_mark)
  end

  def horizontal_wins(board_size, winning_mark)
    (0...board_size).each_with_object([]) do |row, winning_boards|
      board = blank_board(board_size)
      (0...board_size).each { |col| board.mark_cell(winning_mark, row, col) }
      winning_boards << board
    end
  end

  def vertical_wins(board_size, winning_mark)
    (0...board_size).each_with_object([]) do |col, winning_boards|
      board = blank_board(board_size)
      (0...board_size).each { |row| board.mark_cell(winning_mark, row, col) }
      winning_boards << board
    end
  end

  def diagonal_wins(board_size, winning_mark)
    ldiag_board = blank_board(board_size)
    (0...board_size).each do |index|
      ldiag_board.mark_cell(winning_mark, index, index)
    end

    rdiag_board = blank_board(board_size)
    (0...board_size).each do |index|
      rdiag_board.mark_cell(winning_mark, index, rdiag_board.size - index - 1)
    end

    [ldiag_board, rdiag_board]
  end
end
