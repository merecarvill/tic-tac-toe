require "spec_helper"
require "negamax"

module TicTacToe
  describe Negamax do
    def new_negamax(parameters)
      Negamax.new(parameters)
    end

    describe "#apply" do
      context "when given node meets the end-node criterion" do
        it "returns the given node" do
          parameters = {
            child_node_generator: nil,
            terminal_node_criterion: ->(_) { true },
            evaluation_heuristic: nil
          }
          negamax = new_negamax(parameters)

          expect(negamax.apply(:terminal_node)).to eq :terminal_node
        end
      end

      context "when given node does not meet the given end-node criterion" do
        it "returns the highest scoring child node" do
          child_nodes = [{id: 1, score: 1}, {id: 2, score: 0}, {id: 3, score: -1}]
          parameters = {
            child_node_generator: ->(_) { child_nodes },
            terminal_node_criterion: ->(node) { node[:id] > 0 },
            evaluation_heuristic: ->(node) { node[:score] }
          }
          negamax = new_negamax(parameters)

          expect(negamax.apply({id: 0})).to eq child_nodes.max_by { |n| n[:score] }
        end

        it "applies the child node generator to obtain child nodes to score" do
          parameters = {
            child_node_generator: ->(_) { [:child_node] },
            terminal_node_criterion: ->(node) { node == :child_node },
            evaluation_heuristic: ->(_) { 0 }
          }
          negamax = new_negamax(parameters)

          expect(parameters[:child_node_generator]).to receive(:call).and_call_original
          negamax.apply(:initial_node)
        end

        it "applies the evaluation scheme to obtain a score for child nodes" do
          parameters = {
            child_node_generator: ->(_) { [:child_node] },
            terminal_node_criterion: ->(node) { node == :child_node },
            evaluation_heuristic: ->(_) { 0 }
          }
          negamax = new_negamax(parameters)

          heuristic = parameters[:evaluation_heuristic]
          expect(heuristic).to receive(:call).with(:child_node).and_call_original
          negamax.apply(:initial_node)
        end

        context "when given a root node with a depth of 3" do
          let(:root_node) do
            {id: 0, score: nil, children: [
              {id: 1, score: nil, children: [
                {id: 3, score: 1, children: nil},
                {id: 4, score: -1, children: nil}
              ]},
              {id: 2, score: nil, children: [
                {id: 5, score: 0, children: nil},
                {id: 6, score: 0, children: nil}
              ]}
            ]}
          end

          it "returns the node whose children have the highest minimum score" do
            parameters = {
              child_node_generator: ->(node) { node[:children] },
              terminal_node_criterion: ->(node) { node[:children].nil? },
              evaluation_heuristic: ->(node) { node[:score] }
            }
            negamax = new_negamax(parameters)

            expect(negamax.apply(root_node)[:id]).to eq 2
          end
        end
      end
    end
  end
end