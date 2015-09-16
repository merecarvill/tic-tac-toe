require "spec_helper"

module TicTacToe
  describe HumanPlayer do
    include_context "default_values"

    let(:interface) { double("CommandLineInterface") }
    let(:human_player) do
      HumanPlayer.new(
        interface: interface,
        player_mark: @default_first_player)
    end

    describe "#move" do
      it "returns the coordinates of the move selected by the player" do
        allow(interface).to receive(:solicit_move).and_return([0, 0])

        expect(human_player.move).to eq [0, 0]
      end
    end
  end
end
