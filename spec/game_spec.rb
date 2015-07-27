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

  describe '#handle_turns' do

    it 'executes turns until the game is over' do
      allow(game.interface).to receive(:game_setup_interaction).and_return([:human, :computer])
      game.set_up
      allow(game).to receive(:over?).and_return(false, false, false, false, true)
      allow(game).to receive(:handle_one_turn)

      expect(game).to receive(:handle_one_turn).exactly(5).times
      game.handle_turns
    end
  end

  describe '#handle_one_turn' do
    let(:player_stub) { Object.new }

    before do
      allow(player_stub).to receive(:player_mark).and_return(@default_first_player)
      allow(player_stub).to receive(:move).and_return([0, 0])
    end

    it 'displays the game board via the interface' do
      allow(game.interface).to receive(:report_move)

      expect(game.interface).to receive(:show_game_board)
      game.handle_one_turn(player_stub)
    end

    it 'gets valid move coordinates from given player' do
      allow(game.interface).to receive(:show_game_board)
      allow(game.interface).to receive(:report_move)

      expect(game).to receive(:get_valid_move).and_return([0, 0])
      game.handle_one_turn(player_stub)
    end

    it 'marks the game board with player\'s mark at the coordinates given by player' do
      allow(game.interface).to receive(:show_game_board)
      allow(game.interface).to receive(:report_move)
      game.handle_one_turn(player_stub)

      expect(game.board[0, 0]).to eq @default_first_player
    end

    it 'reports the move that was just made through the interface' do
      allow(game.interface).to receive(:show_game_board)

      expect(game.interface).to receive(:report_move).with(@default_first_player, [0, 0])
      game.handle_one_turn(player_stub)
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

  describe '#over?' do

    it 'returns true when the board has a winning line' do
      allow(game.board).to receive(:has_winning_line?).and_return(true)

      expect(game.over?).to be true
    end

    it 'returns true if the board is filled' do
      allow(game.board).to receive(:filled?).and_return(true)

      expect(game.over?).to be true
    end

    it 'returns false when the game is not over' do
      expect(game.over?).to be false
    end
  end
end