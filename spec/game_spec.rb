require 'spec_helper'

describe TicTacToe::Game do
  let(:game) { described_class.new({}) }

  describe '#initialize' do

    it 'initializes a board and stores it in an instance variable' do
      expect(game.board).to be_a TicTacToe::Board
    end

    it 'initializes an interface and stores it in an instance variable' do
      expect(game.interface).to be_a TicTacToe::Interface
    end

    context 'when given parameters' do

      it 'creates a board of the given size' do
        custom_game = described_class.new(board_size: 4)

        expect(custom_game.board.size).to eq 4
      end

      it 'uses player marks of the given type' do
        custom_game = described_class.new(player_marks: [:F, :B])

        expect(custom_game.player_marks).to eq [:F, :B]
      end
    end
  end

  describe '#set_up' do

    it 'uses information from the interface to create the players' do
      allow(game.interface).to receive(:game_setup_interaction).and_return([:human, :computer])
      game.set_up

      game.players.each do |player|
        expect(player).to be_a TicTacToe::Player
      end
    end
  end
end