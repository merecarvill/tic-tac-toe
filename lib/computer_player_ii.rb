require "negamax"

module TicTacToe
  class ComputerPlayerII
    def initialize(parameters)
      @board = parameters[:board]
      @player_mark = parameters[:player_mark]
      @opponent_mark = parameters[:opponent_mark]
    end

    def move
      if @board.all_blank? && @board.size.odd?
        [:row, :col].map { @board.size / 2 }
      else
        # @board.blank_cell_coordinates.sample
        choose_best_move
      end
    end

    private

    def choose_best_move
      @negamax ||= create_negamax
      @negamax.apply(@board).last_move_made
    end

    def create_negamax
      parameters = {
        child_node_generator: create_child_node_generator,
        terminal_node_criterion: create_terminal_node_criterion,
        evaluation_heuristic: create_evaluation_heuristic
      }
      Negamax.new(parameters)
    end

    def create_child_node_generator
      lambda do |board|
        mark = ([@player_mark, @opponent_mark] - [board.last_mark_made]).pop
        board.blank_cell_coordinates.map do |coordinates|
          child = board.deep_copy
          child.mark_cell(mark, *coordinates)
          child
        end
      end
    end

    def create_terminal_node_criterion
      lambda do |board|
        board.has_winning_line? || board.all_marked?
      end
    end

    def create_evaluation_heuristic
      lambda do |board|
        board.lines.each do |line|
          return 1 if line.all? { |cell|  cell == @player_mark }
          return -1 if line.all? { |cell|  cell == @opponent_mark }
        end
        0
      end
    end
  end
end