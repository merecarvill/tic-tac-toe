require 'spec_helper'

describe TicTacToe::Player do
  include_context 'helper_methods'
  include_context 'default_values'

  let(:human_player) {
    described_class.new(
      type: :human,
      board: new_board(@default_board_size),
      player: @default_first_player,
      opponent: @default_second_player)
  }
  let(:computer_player) {
    described_class.new(
      type: :computer,
      board: new_board(@default_board_size),
      player: @default_first_player,
      opponent: @default_second_player)
  }
  let(:player_examples) { [human_player, computer_player] }

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
        expect{ player }.not_to raise_error
      end
    end

    context 'when initialized as a human player' do

      it 'takes functionality from HumanPlayer' do
        expect(human_player.player).to be_a TicTacToe::HumanPlayer
      end
    end

    context 'when initialized as a computer player' do

      it 'takes functionality from ComputerPlayer' do
        expect(computer_player.player).to be_a TicTacToe::ComputerPlayer
      end
    end
  end

  describe '#player_mark' do

    it 'is implemented' do
      player_examples.each do |player|
        expect(player.respond_to?(:player_mark)).to be true
      end
    end
  end

  describe '#move' do

    it 'is implemented' do
      player_examples.each do |player|
        expect(player.respond_to?(:move)).to be true
      end
    end
  end
end