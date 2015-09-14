module TicTacToe
  class Minimax
    def initialize(parameters)
      @end_state_criterion = parameters[:end_state_criterion]
      @evaluation_scheme = parameters[:evaluation_scheme]
    end

    def score(game_state)
      if end_state?(game_state)
        evaluate(game_state)
      end
    end

    private

    def end_state?(game_state)
      @end_state_criterion.call(game_state)
    end

    def evaluate(game_state)
      @evaluation_scheme.call(game_state)
    end
  end
end