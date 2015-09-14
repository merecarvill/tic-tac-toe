require 'spec_helper'

module TicTacToe
  describe Minimax do
    describe '#initialize' do
      it 'takes a function that identifies end states and a scheme for evaluating end states' do
        parameters = {
          end_state_criterion: ->(_) { true },
          evaluation_scheme: ->(_) { 0 }
        }

        expect{described_class.new(parameters)}.not_to raise_error
      end
    end

    describe '#score' do
      context 'when given state meets the give end state criterion' do
        it 'returns the result of applying the evaluation scheme to given state' do
          parameters = {
            end_state_criterion: ->(_) { true },
            evaluation_scheme: ->(_) { :result }
          }
          minimax = described_class.new(parameters)

          expect(minimax.score(double("a game state"))).to eq :result
        end
      end
    end
  end
end