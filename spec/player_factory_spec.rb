require "spec_helper"
require "player_factory"

require "game"

module TicTacToe
  describe PlayerFactory do
    include_context "default_values"

    describe ".build" do
      let(:player_types) { [AvailablePlayerTypes::HUMAN, AvailablePlayerTypes::COMPUTER] }
      let(:player_classes) { [HumanPlayer, ComputerPlayer] }
      let(:player_config) do
        {
          game: Game.new({}),
          player_mark: @default_player_marks.first
        }
      end

      def build_player(config)
        PlayerFactory.build(config)
      end

      it "creates a player of the given type" do
        player_types.zip(player_classes).each do |type, player_class|
          player_config[:type] = type

          expect(build_player(player_config)).to be_a player_class
        end
      end

      it "creates players that respond to #move" do
        player_types.each do |type|
          player_config[:type] = type

          expect(build_player(player_config)).to respond_to :move
        end
      end

      it "creates players that use the given mark" do
        player_types.each do |type|
          player_config[:type] = type

          expect(build_player(player_config).player_mark).to eq player_config[:player_mark]
        end
      end
    end
  end
end