require 'spec_helper'

module TicTacToe
  describe Player do
    include_context 'default_values'
    include_context 'helper_methods'

    let(:human_player) do
      described_class.new(
        type: :human,
        interface: Interface.new(:command_line),
        player_mark: @default_first_player)
    end
    let(:computer_player) do
      described_class.new(
        type: :computer,
        board: new_board(@default_board_size),
        player_mark: @default_first_player,
        opponent_mark: @default_second_player)
    end
    let(:player_examples) { [human_player, computer_player] }
    let(:player_error) { Player::PlayerError }

    describe '.requred_methods' do
      it 'provides the name of each method that must be implemented' do
        methods = [:move, :player_mark]
        methods.each do |method|
          expect(described_class.required_methods.include?(method)).to be true
        end
        expect(described_class.required_methods - methods).to eq []
      end
    end

    describe '#initialize' do
      it 'takes a hash of parameters' do
        player_examples.each do |player|
          expect { player }.not_to raise_error
        end
      end

      context 'when given unrecognized player type' do
        it 'raises error' do
          expect { described_class.new(type: :invalid_type) }.to raise_error(player_error)
        end
      end

      context 'when initialized as a human player' do
        it 'takes functionality from HumanPlayer' do
          expect(human_player.player).to be_a HumanPlayer
        end
      end

      context 'when initialized as a computer player' do
        it 'takes functionality from ComputerPlayer' do
          expect(computer_player.player).to be_a ComputerPlayer
        end
      end
    end

    describe '#player_mark' do
      it 'is implemented by each type of player' do
        player_examples.each do |player|
          expect(player.respond_to?(:player_mark)).to be true
        end
      end

      it 'raises error when not implemented by the functionality-providing object' do
        player_examples.each do |player|
          allow(player.player).to receive(:respond_to?).and_return(false)
          expect { player.player_mark }.to raise_error(player_error)
        end
      end
    end

    describe '#move' do
      it 'is implemented by each type of player' do
        player_examples.each do |player|
          expect(player.respond_to?(:move)).to be true
        end
      end

      it 'raises error when not implemented by the functionality-providing object' do
        player_examples.each do |player|
          allow(player.player).to receive(:respond_to?).and_return(false)
          expect { player.move }.to raise_error(player_error)
        end
      end
    end
  end
end
