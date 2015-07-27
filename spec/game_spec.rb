require 'spec_helper'

describe TicTacToe::Game do
  include_context "default_values"

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

  describe '#get_valid_move' do
    let(:player_stub) { Object.new }

    before do
      allow(player_stub).to receive(:player_mark)
    end

    context 'when it receieves valid move coordinates from given player' do

      it 'returns those coordinates' do
        allow(player_stub).to receive(:move).and_return([0, 0])

        expect(game.get_valid_move(player_stub)).to eq [0, 0]
      end
    end

    context 'when it receives invalid move coordinates from given player' do
      let(:occupied_coordinates) { [0, 0] }
      let(:out_of_bounds_coordinates) { [0, game.board.size] }
      let(:valid_coordinates) { [0, game.board.size - 1] }

      before do
        game.board[0, 0] = @default_first_player
        allow(player_stub).to receive(:move).and_return(
          occupied_coordinates,
          out_of_bounds_coordinates,
          valid_coordinates)
      end

      it 'complains through the interface' do
        expect(game.interface).to receive(:report_invalid_move).exactly(2).times

        game.get_valid_move(player_stub)
      end

      it 'gets another move from player until it receives valid coordinates' do
        allow(game.interface).to receive(:report_invalid_move)

        expect(game.get_valid_move(player_stub)).to eq valid_coordinates
      end
    end
  end
end