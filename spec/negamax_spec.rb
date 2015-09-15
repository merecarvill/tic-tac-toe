require 'spec_helper'

module TicTacToe
  describe Negamax do
    describe '#score' do
      context 'when given node meets the end-node criterion' do
        let(:result) { 1 }

        context 'when it is initial player\'s turn' do
          let(:color) { 1 }

          it 'returns the result of applying the evaluation scheme to given node' do
            parameters = {
              child_node_generator: nil,
              terminal_node_criterion: ->(_) { true },
              evaluation_heuristic: ->(_) { result }
            }
            minimax = described_class.new(parameters)

            expect(minimax.score(:initial_node, color)).to eq result
          end
        end

        context 'when it is not initial player\'s turn' do
          let(:color) { -1 }

          it 'returns the negation of applying the evaluation scheme to given node' do
            parameters = {
              child_node_generator: nil,
              terminal_node_criterion: ->(_) { true },
              evaluation_heuristic: ->(_) { result }
            }
            minimax = described_class.new(parameters)

            expect(minimax.score(:initial_node, color)).to eq result * -1
          end
        end
      end

      context 'when given node does not meet the given end-node criterion' do
        it 'applies child node generator to given node' do
          parameters = {
            child_node_generator: ->(_) { (0..2).map{ :child_node } },
            terminal_node_criterion: ->(node) { node == :child_node },
            evaluation_heuristic: ->(_) { 0 }
          }
          minimax = described_class.new(parameters)

          expect(minimax).to receive(:generate_child_nodes).once.and_call_original
          minimax.score(:initial_node, 1)
        end

        it 'calls #score to evaluate every child node' do
          parameters = {
            child_node_generator: ->(_) { (0..2).map{ :child_node } },
            terminal_node_criterion: ->(node) { node == :child_node },
            evaluation_heuristic: ->(_) { 0 }
          }
          minimax = described_class.new(parameters)

          # initial call + 3 child nodes
          expect(minimax).to receive(:score).exactly(4).times.and_call_original
          minimax.score(:initial_node, 1)
        end

        it 'returns the highest score resulting from evaluating the child nodes' do
          scores = (0..2).to_a
          parameters = {
            child_node_generator: ->(_) { (0..2).map{ :child_node } },
            terminal_node_criterion: ->(node) { node == :child_node },
            evaluation_heuristic: ->(_) { scores.pop }
          }
          minimax = described_class.new(parameters)

          expect(minimax.score(:initial_node, 1)).to eq (0..2).to_a.max
        end
      end
    end
  end
end