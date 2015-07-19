module TicTacToe
  class Board
    BoardError = Class.new(StandardError)

    attr_reader :size

    def initialize(parameters)
      @size = parameters[:size] || 3
      generate_new_board
      deep_copy_board(parameters[:board]) if parameters[:board]
    end

    def []=(row, col, mark)
      raise BoardError, 'Cannot alter marked cell' unless @cells[row][col].nil?

      @cells[row][col] = mark
    end

    def [](row, col)
      raise_error_if_out_of_bounds(row, col)

      @cells[row][col]
    end

    def lines
      lines = [left_diag, right_diag]
      (0...@size).each{ |index| lines << row_at(index) << col_at(index) }
      lines
    end

    def blank_cell_coordinates
      (0...@size).each_with_object([]) do |row, coordinates|
        (0...@size).each do |col|
          coordinates << [row, col] if @cells[row][col].nil?
        end
      end
    end

    def deep_copy
      Board.new({size: @size, board: self})
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

    def filled?
      !@cells.flatten.any?(&:nil?)
    end

    def has_winning_line?
      self.lines.each do |line|
        return true if !line.first.nil? && line.all?{ |cell| cell == line.first }
      end
      return false
    end

    private

    def generate_new_board
      @cells = (0...@size).map{ (0...@size).map{ nil } }
    end

    def deep_copy_board(board)
      raise BoardError, 'Given board is incorrect size' if board.size != @size

      (0...@size).each do |row|
        (0...@size).each do |col|
          self[row, col] = board[row, col]
        end
      end
    end

    def row_at(row)
      @cells[row]
    end

    def col_at(col)
      (0...@size).map{ |row| @cells[row][col] }
    end

    def left_diag
      (0...@size).map{ |index| @cells[index][index] }
    end

    def right_diag
      (0...@size).map{ |row| @cells[row][@size - row - 1] }
    end

    def raise_error_if_out_of_bounds(row, col)
      raise BoardError, 'Cell coordinates are out of bounds' if row >= @size || col >= @size
    end
  end
end