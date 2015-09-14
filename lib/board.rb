module TicTacToe
  class Board
    BoardError = Class.new(StandardError)
    BLANK_MARK = nil

    attr_reader :size, :last_move_made

    def self.blank_mark
      BLANK_MARK
    end

    def initialize(parameters)
      fail BoardError, 'Given size is too small, must be 3 or greater' if parameters[:size] < 3
      @size = parameters[:size]
      generate_new_board
      deep_copy_board(parameters[:board]) if parameters[:board]
      initialize_cells(parameters[:config]) if parameters[:config]
    end

    def []=(row, col, mark)
      fail BoardError, 'Cell coordinates are out of bounds' if out_of_bounds?([row, col])
      fail BoardError, 'Cannot alter marked cell' unless blank?([row, col])

      @last_move_made = [row, col]
      @cells[row][col] = mark
    end

    def [](row, col)
      fail BoardError, 'Cell coordinates are out of bounds' if out_of_bounds?([row, col])

      @cells[row][col]
    end

    def lines
      (0...@size).each_with_object([left_diag, right_diag]) do |index, lines|
        lines << row_at(index) << col_at(index)
      end
    end

    def all_coordinates
      (0...@size).to_a.repeated_permutation(2).to_a
    end

    def blank_cell_coordinates
      all_coordinates.reject { |coordinates| marked?(coordinates) }
    end

    def last_mark_made
      return if @last_move_made.nil?
      self[*last_move_made]
    end

    def deep_copy
      Board.new(size: @size, board: self)
    end

    def blank?(coordinates)
      self[*coordinates] == BLANK_MARK
    end

    def marked?(coordinates)
      !blank?(coordinates)
    end

    def out_of_bounds?(coordinates)
      coordinates.any? { |i| !i.between?(0, @size - 1) }
    end

    def all_blank?
      all_coordinates.all? { |coordinates| blank?(coordinates) }
    end

    def all_marked?
      all_coordinates.all? { |coordinates| marked?(coordinates) }
    end

    def has_winning_line?
      lines.each do |line|
        return true if line.first != BLANK_MARK && line.all? { |cell| cell == line.first }
      end
      false
    end

    private

    def initialize_cells(config)
      if Math.sqrt(config.size).to_i != @size
        fail BoardError, 'Given size does not reconcile with given configuration'
      end

      all_coordinates.zip(config).each do |coordinates, mark|
        self[*coordinates] = mark
      end
    end

    def generate_new_board
      @cells = (0...@size).map { (0...@size).map { BLANK_MARK } }
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
  end
end
