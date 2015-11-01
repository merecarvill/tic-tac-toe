require "spec_helper"
require "player_factory"

require "game"

module TicTacToe
  describe PlayerFactory do
    include_context "default_values"

    describe ".build" do
      let(:player_types) { [AvailablePlayerTypes::HUMAN, AvailablePlayerTypes::COMPUTER] }
      let(:player_classes) { [HumanPlayer, ComputerPlayer] }
      let(:player_parameters) do
        {
          game: Game.new({}),
          player_mark: @default_player_marks.first
        }
      end

      def build_player(player_parameters)
        PlayerFactory.build(player_parameters)
      end

      it "creates a player of the given type" do
        player_types.zip(player_classes).each do |type, player_class|
          player_parameters[:type] = type

          expect(build_player(player_parameters)).to be_a player_class
        end
      end

      it "creates players that respond to #move" do
        player_types.each do |type|
          player_parameters[:type] = type

          expect(build_player(player_parameters)).to respond_to :move
        end
      end

      it "creates players that use the given mark" do
        player_types.each do |type|
          player_parameters[:type] = type

          expect(build_player(player_parameters).player_mark).to eq player_parameters[:player_mark]
        end
      end
    end
  end
end