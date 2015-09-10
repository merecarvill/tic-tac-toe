require 'spec_helper'

module TicTacToe
  describe Game do
    include_context 'default_values'

    let(:game) { described_class.new({}) }

    describe '#initialize' do
      it 'initializes a board and stores it in an instance variable' do
        expect(game.board).to be_a Board
      end

      context 'when given parameters' do
        it 'uses given board' do
          board = Board.new(size: 4)
          custom_game = described_class.new(board: board)

          expect(custom_game.board).to eq board
        end

        it 'uses player marks of the given type' do
          custom_game = described_class.new(player_marks: [:F, :B])

          expect(custom_game.player_marks).to eq [:F, :B]
        end

        it 'uses the given interface' do
          interface = CommandLineInterface.new
          custom_game = described_class.new(interface: interface)

          expect(custom_game.interface).to eq interface
        end
      end

      context 'when a given parameter is not provided' do
        it 'creates and uses a board of default size' do
          expect(game.board.size).to eq @default_board_size
        end

        it 'uses a default set of player marks' do
          game.player_marks.each do |default_mark|
            expect(@default_player_marks).to include default_mark
          end
        end

        it 'creates and uses a command line interface by default' do
          expect(game.interface).to be_a CommandLineInterface
        end
      end
    end

    describe '#run' do
      it 'sets up the game' do
        allow(game).to receive(:handle_turns)
        allow(game).to receive(:handle_game_over)

        expect(game).to receive(:set_up)
        game.run
      end

      it 'handles each turn' do
        allow(game).to receive(:handle_game_over)
        allow(game).to receive(:set_up)

        expect(game).to receive(:handle_turns)
        game.run
      end

      it 'handles the end of the game' do
        allow(game).to receive(:set_up)
        allow(game).to receive(:handle_turns)

        expect(game).to receive(:handle_game_over)
        game.run
      end
    end

    describe '#set_up' do
      it 'uses information from the interface to create the players' do
        allow(game.interface).to receive(:game_setup_interaction).and_return([:human, :computer])
        game.set_up

        game.players.each_with_index do |player, index|
          expect(player.respond_to?(:move)).to be true
          expect(player).to be_a index == 0 ? HumanPlayer : ComputerPlayer
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

      context 'when it receives valid move coordinates from given player' do
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

    describe '#handle_game_over' do
      it 'shows the final state of the game board via the interface' do
        allow(game.interface).to receive(:report_game_over)

        expect(game.interface).to receive(:show_game_board)
        game.handle_game_over
      end

      context 'when game has been won' do
        it 'reports that the given last player to move has won via the interface' do
          allow(game.interface).to receive(:show_game_board)
          allow(game.board).to receive(:has_winning_line?).and_return(true)
          allow(game.board).to receive(:last_mark_made).and_return(@default_first_player)

          expect(game.interface).to receive(:report_game_over).with(@default_first_player)
          game.handle_game_over
        end
      end

      context 'when game has no winner' do
        it 'reports that game ended in a draw via the interface' do
          allow(game.interface).to receive(:show_game_board)
          allow(game.board).to receive(:last_mark_made).and_return(@default_first_player)

          expect(game.interface).to receive(:report_game_over).with(:none)
          game.handle_game_over
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

    describe 'integration tests' do
      let(:game) { described_class.new({}) }

      before do
          allow(game.interface).to receive(:show_game_board)
          allow(game.interface).to receive(:solicit_move)
          allow(game.interface).to receive(:report_move)
          allow(game.interface).to receive(:report_invalid_move)
          allow(game.interface).to receive(:report_game_over)
      end

      context 'in a game with two computer players' do
        before do
          allow(game.interface).to receive(:game_setup_interaction).and_return([:computer, :computer])
        end

        it 'should end the game in a draw' do
          game.run

          expect(game.board.has_winning_line?).to be false
          expect(game.board.filled?).to be true
        end
      end

      context 'in a game with a human player and a computer player' do
        before do
          allow(game.interface).to receive(:game_setup_interaction).and_return([:human, :computer])
        end

        it 'should end in a win for the computer player against an unskilled human player' do
          allow(game.interface).to receive(:solicit_move) do
            game.board.blank_cell_coordinates.first
          end
          computer_player_mark = :o
          game.run

          expect(game.board.has_winning_line?).to be true
          expect(game.board.last_mark_made).to be computer_player_mark
        end
      end
    end
  end
end
