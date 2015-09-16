module TicTacToe
  class Negamax
    def initialize(parameters)
      @child_node_generator = parameters[:child_node_generator]
      @terminal_node_criterion = parameters[:terminal_node_criterion]
      @evaluation_heuristic = parameters[:evaluation_heuristic]
    end

    def apply(node)
      if terminal_node?(node)
        node
      else
        generate_child_nodes(node).max_by { |child| -score(child, -1) }
      end
    end

    private

    def score(node, color)
      if terminal_node?(node)
        evaluate(node, color)
      else
        generate_child_nodes(node).map { |child| -score(child, -color) }.max
      end
    end

    def generate_child_nodes(node)
      @child_node_generator.call(node)
    end

    def terminal_node?(node)
      @terminal_node_criterion.call(node)
    end

    def evaluate(node, color)
      @evaluation_heuristic.call(node) * color
    end
  end
end