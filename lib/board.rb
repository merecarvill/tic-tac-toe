module TicTacToe
  class Board
    attr_reader :size

    def initialize(perameters)
      @size = perameters[:size]
      generate_new_board
    end

    def num_cells
      @cells.flatten.count
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