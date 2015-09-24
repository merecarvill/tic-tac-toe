require "negamax"

module TicTacToe
  class ComputerPlayer
    attr_reader :player_mark

    def initialize(parameters)
      @board = parameters[:board]
      @player_mark = parameters[:player_mark]
      @opponent_mark = parameters[:opponent_mark]
    end

    def move
      if @board.all_blank? && @board.size.odd?
        [:row, :col].map { @board.size / 2 }
      else
        choose_best_move
      end
    end

    private

    def choose_best_move
      @negamax ||= create_negamax
      @negamax.apply(initial_node).fetch(:last_move_made)
    end

    def create_negamax
      parameters = {
        child_node_generator: create_child_node_generator,
        terminal_node_criterion: create_terminal_node_criterion,
        evaluation_heuristic: create_evaluation_heuristic
      }
      Negamax.new(parameters)
    end

    def initial_node
      {
        board: @board,
        current_player_mark: @player_mark,
        last_move_made: nil
      }
    end

    def create_child_node_generator
      lambda do |node|
        board = node.fetch(:board)
        current_player_mark = node.fetch(:current_player_mark)

        board.blank_cell_coordinates.map do |coordinates|
          child_node = {
            board: board.deep_copy,
            current_player_mark: toggle_mark(current_player_mark),
            last_move_made: coordinates
          }
          child_node[:board].mark_cell(current_player_mark, *coordinates)
          child_node
        end
      end
    end

    def create_terminal_node_criterion
      lambda do |node|
        board = node.fetch(:board)

        board.has_winning_line? || board.all_marked?
      end
    end

    def create_evaluation_heuristic
      lambda do |node|
        board = node.fetch(:board)

        board.lines.each do |line|
          return 1 if line.all? { |cell|  cell == @player_mark }
          return -1 if line.all? { |cell|  cell == @opponent_mark }
        end
        0
      end
    end

    def toggle_mark(mark)
      mark == @player_mark ? @opponent_mark : @player_mark
    end
  end
end