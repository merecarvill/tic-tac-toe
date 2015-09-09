require 'spec_helper'

module TicTacToe
  describe PlayerFactory do
    include_context 'default_values'
    let(:player_factory) { described_class.new({game: Game.new({})}) }

    describe '#initialize' do
      it 'takes a parameter specifying the current game instance' do
        parameters = {game: Game.new({})}

        expect{ described_class.new(parameters) }.not_to raise_error
      end
    end

    describe '#build' do
      let(:player_types) { {human: HumanPlayer, computer: ComputerPlayer} }
      let(:build_parameters) do
        {player_mark: @default_player_marks.first, opponent_mark: @default_player_marks.last}
      end

      it 'creates a player of the given type' do
        player_types.each do |type, associated_class|
          build_parameters[:type] = type
          player = player_factory.build(build_parameters)

          expect(player).to be_a associated_class
        end
      end
    end
  end
end