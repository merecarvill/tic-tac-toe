module TicTacToe
  class Board
    BoardError = Class.new(StandardError)

    attr_reader :size

    def initialize(perameters)
      @size = perameters[:size]
      generate_new_board
    end

    def []=(row, col, mark)
      raise BoardError, 'Cannot alter marked cell' unless @cells[row][col].nil?
      @cells[row][col] = mark
    end

    def [](row, col)
      raise_error_if_out_of_bounds(row, col)

      @cells[row][col]
    end

    def intersecting_lines(row, col)
      raise_error_if_out_of_bounds(row, col)

      lines = [row_at(row), col_at(col)]
      lines << left_diag if row == col
      lines << right_diag if row + col == @size - 1
      lines
    end

    def num_cells
      @cells.flatten.count
    end

    def marked?(row, col)
      @cells[row][col] != nil
    end

    def blank?
      @cells.flatten.all?(&:nil?)
    end

    private

    def generate_new_board
      @cells = []
      @size.times do
        @cells << (1..@size).map{nil}
      end
    end

    def row_at(row)
      {row: row, cells: @cells[row]}
    end

    def col_at(col)
      {col: col, cells: (0...@size).map{ |row| @cells[row][col] }}
    end

    def left_diag
      {left_diag: true, cells: (0...@size).map{ |index| @cells[index][index] }}
    end

    def right_diag
      {right_diag: true, cells: (0...@size).map{ |row| @cells[row][@size - row - 1] }}
    end

    def raise_error_if_out_of_bounds(row, col)
      raise BoardError, 'Cell coordinates are out of bounds' if row >= @size || col >= @size
    end
  end
end