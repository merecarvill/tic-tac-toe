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
      @cells.fetch(row).fetch(col)
    rescue IndexError
      raise BoardError, 'Cell coordinates are out of bounds'
    end

    def num_cells
      @cells.flatten.count
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
  end
end