module TicTacToe
  class Board
    BoardError = Class.new(StandardError)

    attr_reader :size, :last_move_made

    def initialize(parameters)
      fail BoardError, 'Given size is too small, must be 3 or greater' if parameters[:size] < 3
      @size = parameters[:size]
      generate_new_board
      deep_copy_board(parameters[:board]) if parameters[:board]
    end

    def []=(row, col, mark)
      raise_error_if_out_of_bounds(row, col)
      fail BoardError, 'Cannot alter marked cell' unless @cells[row][col].nil?

      @last_move_made = [row, col]
      @cells[row][col] = mark
    end

    def [](row, col)
      raise_error_if_out_of_bounds(row, col)

      @cells[row][col]
    end

    def lines
      lines = [left_diag, right_diag]
      (0...@size).each { |index| lines << row_at(index) << col_at(index) }
      lines
    end

    def blank_cell_coordinates
      (0...@size).each_with_object([]) do |row, coordinates|
        (0...@size).each do |col|
          coordinates << [row, col] if self[row, col].nil?
        end
      end
    end

    def last_mark_made
      return if @last_move_made.nil?
      self[*last_move_made]
    end

    def deep_copy
      Board.new(size: @size, board: self)
    end

    def num_cells
      @cells.flatten.count
    end

    def marked?(coordinates)
      !self[*coordinates].nil?
    end

    def out_of_bounds?(coordinates)
      coordinates.any? { |i| !i.between?(0, @size - 1) }
    end

    def blank?
      @cells.flatten.all?(&:nil?)
    end

    def filled?
      @cells.flatten.none?(&:nil?)
    end

    def has_winning_line?
      lines.each do |line|
        return true if !line.first.nil? && line.all? { |cell| cell == line.first }
      end
      false
    end

    def game_over?
      has_winning_line? || filled?
    end

    private

    def generate_new_board
      @cells = (0...@size).map { (0...@size).map { nil } }
    end

    def deep_copy_board(board)
      fail BoardError, 'Given size does not match given board' if board.size != @size

      (0...@size).each do |row|
        (0...@size).each do |col|
          self[row, col] = board[row, col]
        end
      end
    end

    def row_at(row)
      (0...@size).map { |col| self[row, col] }
    end

    def col_at(col)
      (0...@size).map { |row| self[row, col] }
    end

    def left_diag
      (0...@size).map { |index| self[index, index] }
    end

    def right_diag
      (0...@size).map { |row| self[row, @size - row - 1] }
    end

    def raise_error_if_out_of_bounds(row, col)
      fail BoardError, 'Cell coordinates are out of bounds' if row >= @size || col >= @size
    end
  end
end
