require 'rspec'
require 'rspec/collection_matchers'
require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/human_player'
require_relative '../lib/computer_player'
require_relative '../lib/command_line_interface'

RSpec.shared_context 'default_values' do
  before :all do
    @default_board_size = 3
    @default_first_player = :x
    @default_second_player = :o
    @default_player_marks = [:x, :o]
    @default_player_types = [:human, :computer]
  end
end

RSpec.shared_context 'helper_methods' do
  def at_least_one_repeated_line?(string)
    lines = string.split("\n")
    lines.uniq.length < lines.length
  end

  def random_coordinates(board_size)
    [rand(board_size), rand(board_size)]
  end

  def all_coordinates(board_size)
    (0...board_size).to_a.repeated_permutation(2).to_a
  end

  def new_board(board_size)
    TicTacToe::Board.new(size: board_size)
  end

  def board_with_potential_win_loss_or_draw(board_size, player_marks)
    first_mark, second_mark = player_marks
    board = new_board(board_size)
    (0...board_size - 1).each { |col| board[0, col] = first_mark }
    (0...board_size - 1).each { |col| board[1, col] = second_mark }
    (2...board_size).each do |row|
      (0...board_size - 1).each do |col|
        board[row, col] = col.even? ? first_mark : second_mark
      end
    end
    board
  end

  def board_with_draw(board_size, player_marks)
    first_mark, second_mark = player_marks
    board = new_board(board_size)
    (0...board_size).each do |row|
      (0...board_size).each do |col|
        if row == 0
          board[row, col] = col.odd? ? first_mark : second_mark
        else
          board[row, col] = col.even? ? first_mark : second_mark
        end
      end
    end
    board
  end

  def all_wins(board_size, winning_mark)
    winning_boards = horizontal_wins(board_size, winning_mark)
    winning_boards.concat vertical_wins(board_size, winning_mark)
    winning_boards.concat diagonal_wins(board_size, winning_mark)
  end

  def horizontal_wins(board_size, winning_mark)
    (0...board_size).each_with_object([]) do |row, winning_boards|
      board = new_board(board_size)
      (0...board_size).each { |col| board[row, col] = winning_mark }
      winning_boards << board
    end
  end

  def vertical_wins(board_size, winning_mark)
    (0...board_size).each_with_object([]) do |col, winning_boards|
      board = new_board(board_size)
      (0...board_size).each { |row| board[row, col] = winning_mark }
      winning_boards << board
    end
  end

  def diagonal_wins(board_size, winning_mark)
    ldiag_board = new_board(board_size)
    (0...board_size).each { |index| ldiag_board[index, index] = winning_mark }

    rdiag_board = new_board(board_size)
    (0...board_size).each { |index| rdiag_board[index, rdiag_board.size - index - 1] = winning_mark }

    [ldiag_board, rdiag_board]
  end
end
