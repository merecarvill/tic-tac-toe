require 'spec_helper'

module TicTacToe
  describe HumanPlayer do
    include_context 'default_values'

    let(:interface) { CommandLineInterface.new }
    let(:human_player) do
      described_class.new(
        interface: interface,
        player_mark: @default_first_player)
    end

    it 'implements methods required by Player interface' do
      Player.required_methods.each do |method|
        expect(human_player).to respond_to(method)
      end
    end

    describe '#initialize' do
      it 'takes parameters containing the game interface and the player\'s mark' do
        params = {
          interface: interface,
          player_mark: @default_first_player
        }

        expect { described_class.new(params) }.not_to raise_error
      end
    end

    describe '#move' do
      it 'returns the coordinates of the move selected by the player' do
        allow(interface).to receive(:solicit_move).and_return([0, 0])

        expect(human_player.move).to eq [0, 0]
      end
    end
  end
end
