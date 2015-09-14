require 'spec_helper'

module TicTacToe
  describe CommandLineInterface do
    include_context 'default_values'
    include_context 'helper_methods'

    let(:input_stream) { StringIO.new }
    let(:output_stream) { StringIO.new }
    let(:interface) do
      parameters = { input: input_stream, output: output_stream}
      described_class.new(parameters)
    end

    describe '#intitialize' do
      it 'takes an input stream and an output stream' do
        parameters = { input: input_stream, output: output_stream}

        expect{ described_class.new(parameters) }.not_to raise_error
      end
    end

    describe '#game_setup_interaction' do
      before do
        input_stream.string = %w(human computer).join("\n")
      end

      it 'prints an introductory message to the command line' do
        interface.game_setup_interaction(@default_player_marks)

        expect(output_stream.string).not_to eq ''
      end

      it 'returns the player type associated with each of the given player marks' do
        player_types = interface.game_setup_interaction(@default_player_marks)

        expect(player_types).to have(2).things
        player_types.each do |type|
          expect(@default_player_types).to include type
        end
      end
    end

    describe '#solicit_player_type' do
      let(:valid_input) { 'human' }

      it 'prints a prompt to the command line' do
        input_stream.string = valid_input
        interface.solicit_player_type(@default_first_player)

        expect(output_stream.string).not_to eq ''
      end

      context 'when given valid input' do
        it 'returns the player type input by user' do
          input_stream.string = valid_input

          expect(interface.solicit_player_type(@default_first_player)).to eq valid_input.to_sym
        end
      end

      context 'when given invalid input' do
        let(:invalid_input) { 'foo' }

        it 'prompts the user until given valid input' do
          input_stream.string = invalid_input + "\n" + invalid_input + "\n" + valid_input
          interface.solicit_player_type(@default_first_player)

          expect(at_least_one_repeated_line?(output_stream.string)).to be true
        end
      end
    end

    describe '#show_game_board' do
      it 'prints a respresentation of the given board to the command line' do
        board = board_with_draw(@default_board_size, @default_player_marks)
        interface.show_game_board(board)

        board_characters = output_stream.string.split('')
        cell_count = board.size**2
        expected_first_mark_count = cell_count.odd? ? cell_count / 2 + 1 : cell_count / 2
        expected_second_mark_count = cell_count / 2

        expect(board_characters.count(@default_first_player.to_s)).to eq expected_first_mark_count
        expect(board_characters.count(@default_second_player.to_s)).to eq expected_second_mark_count
      end
    end

    describe 'solicit_move' do
      let(:valid_input) { '0, 0' }

      it 'prints a prompt to the command line' do
        input_stream.string = valid_input
        interface.solicit_move(@default_first_player)

        expect(output_stream.string).not_to eq ''
      end

      context 'when given valid input' do
        it 'returns the move coordinates input by user' do
          input_stream.string = valid_input
          valid_coordinate = valid_input.split(',').map(&:to_i)

          expect(interface.solicit_move(@default_first_player)).to eq valid_coordinate
        end
      end

      context 'when given invalid input' do
        let(:invalid_input) { 'foo' }

        it 'prompts the user until given valid input' do
          input_stream.string = invalid_input + "\n" + invalid_input + "\n" + valid_input
          interface.solicit_move(@default_first_player)

          expect(at_least_one_repeated_line?(output_stream.string)).to be true
        end
      end
    end

    describe '#report_invalid_move' do
      it 'prints a notification that a move cannot be made at the given coordinates' do
        interface.report_invalid_move([0, 0])

        expect(output_stream.string.split('').count('0')).to eq 2
      end
    end

    describe '#report_move' do
      it 'prints a notification of the move made by the given mark at the given coordinates' do
        interface.report_move(@default_first_player, [0, 0])
        interface_output = output_stream.string

        expect(interface_output).to include @default_first_player.to_s
        expect(interface_output.split('').count('0')).to eq 2
      end
    end

    describe '#report_game_over' do
      context 'when given the mark of a winning player' do
        it 'prints a notification that the player has won' do
          expect(interface).to receive(:report_win).with(@default_first_player)
          interface.report_game_over(@default_first_player)
        end
      end

      context 'when winning player is ":none"' do
        it 'prints a notification that the game has ended in a draw' do
          expect(interface).to receive(:report_draw)
          interface.report_game_over(:none)
        end
      end
    end

    describe '#report_win' do
      it 'prints a notification that the player using the given mark has won' do
        interface.report_win(@default_first_player)
        interface_output = output_stream.string

        expect(interface_output).to include @default_first_player.to_s
        expect(interface_output).to include 'wins'
      end
    end

    describe '#report_draw' do
      it 'prints a notification that the game has ended in a draw' do
        interface.report_draw

        expect(output_stream.string).to include 'draw'
      end
    end
  end
end
