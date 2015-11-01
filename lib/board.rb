module TicTacToe
  class Board
    BLANK_MARK = nil

    attr_reader :size, :last_move_made

    def initialize(parameters)
      @size = parameters[:size] || infer_size(parameters[:marked_spaces])
      @spaces = parameters[:marked_spaces] || blank_spaces
      @last_move_made = parameters[:last_move_made]
    end

    def read_space(coordinates)
      @spaces[coordinates_to_flat_index(coordinates)]
    end

    def mark_space(mark, coordinates)
      marked_spaces = @spaces.dup
      marked_spaces[coordinates_to_flat_index(coordinates)] = mark

      Board.new(marked_spaces: marked_spaces, last_move_made: coordinates)
    end

    def last_mark_made
      return if @last_move_made.nil?
      self.read_space(last_move_made)
    end

    def lines
      (0...@size).each_with_object([left_diag, right_diag]) do |index, lines|
        lines << row_at(index) << col_at(index)
      end
    end

    def all_coordinates
      (0...@size).to_a.repeated_permutation(2).to_a
    end

    def blank_space_coordinates
      all_coordinates.reject { |coordinates| marked?(coordinates) }
    end

    def out_of_bounds?(coordinates)
      coordinates.any? { |i| !i.between?(0, @size - 1) }
    end

    def blank?(coordinates)
      self.read_space(coordinates) == BLANK_MARK
    end

    def marked?(coordinates)
      !blank?(coordinates)
    end

    def all_blank?
      all_coordinates.all? { |coordinates| blank?(coordinates) }
    end

    def all_marked?
      all_coordinates.all? { |coordinates| marked?(coordinates) }
    end

    def has_winning_line?
      lines.each do |line|
        return true if line.first != BLANK_MARK && line.all? { |mark| mark == line.first }
      end
      false
    end

    private

    def infer_size(marked_spaces)
      return if marked_spaces.nil?
      Math.sqrt(marked_spaces.count).to_i
    end

    def coordinates_to_flat_index(coordinates)
      row, col = coordinates
      row * @size + col
    end

    def blank_spaces
      Array.new(@size**2) { BLANK_MARK }
    end

    def row_at(row)
      (0...@size).map { |col| self.read_space([row, col]) }
    end

    def col_at(col)
      (0...@size).map { |row| self.read_space([row, col]) }
    end

    def left_diag
      (0...@size).map { |index| self.read_space([index, index]) }
    end

    def right_diag
      (0...@size).map { |row| self.read_space([row, @size - row - 1]) }
    end
  end
end
