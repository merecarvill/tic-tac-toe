require 'spec_helper'

describe TicTacToe::CommandLineInterface do
  include_context "default_values"
  include_context "helper_methods"

  before :all do
    $stdin = StringIO.new
    $stdout = StringIO.new
  end

  after do
    $stdin.string = ""
    $stdout.string = ""
  end

  after :all do
    $stdin = STDIN
    $stdout = STDOUT
  end

  let(:cli) { described_class.new }

  describe '#game_setup_interaction' do
    let(:example_inputs) { ["human", "computer"] }

    it 'prints an introductory message to the command line' do
      $stdin.string = example_inputs.join("\n")
      cli.game_setup_interaction(@default_player_marks)

      expect($stdout.string).not_to eq ""
    end

    it 'returns the player type associated with each of the given player marks' do
      $stdin.string = example_inputs.join("\n")
      player_types = cli.game_setup_interaction(@default_player_marks)

      expect(player_types).to have(2).things
      player_types.each do |type|
        expect(@default_player_types).to include type
      end
    end
  end

  describe '#solicit_player_type' do
  let(:valid_input) { "human" }

    it 'prints a prompt to the command line' do
      $stdin.string = valid_input
      cli.solicit_player_type(@default_first_player)

      expect($stdout.string).not_to eq ""
    end

    context 'when given valid input' do

      it 'returns the player type input by user' do
        $stdin.string = valid_input

        expect(cli.solicit_player_type(@default_first_player)).to eq valid_input.to_sym
      end
    end

    context 'when given invalid input' do
      let(:invalid_input) { "foo" }

      it 'prompts the user until given valid input' do
        $stdin.string = invalid_input + "\n" + invalid_input + "\n" + valid_input
        cli.solicit_player_type(@default_first_player)

        expect(has_at_least_one_repeated_line?($stdout.string)).to be true
      end
    end
  end

  describe '#show_game_board' do

    it 'prints a respresentation of the given board to the command line' do
      board = board_with_draw(@default_board_size, @default_first_player, @default_second_player)
      cli.show_game_board(board)

      board_characters = $stdout.string.split("")
      cell_count = board.size**2
      expected_first_mark_count = cell_count.odd? ? cell_count/2 + 1 : cell_count/2
      expected_second_mark_count = cell_count/2

      expect(board_characters.count(@default_first_player.to_s)).to eq expected_first_mark_count
      expect(board_characters.count(@default_second_player.to_s)).to eq expected_second_mark_count
    end
  end

  describe 'solicit_move' do
    let(:valid_input) { "0, 0" }

    it 'prints a prompt to the command line' do
      $stdin.string = valid_input
      cli.solicit_move(@default_first_player)

      expect($stdout.string).not_to eq ""
    end

    context 'when given valid input' do

      it 'returns the move coordinates input by user' do
        $stdin.string = valid_input
        valid_coordinate = valid_input.split(",").map{ |c| c.to_i }

        expect(cli.solicit_move(@default_first_player)).to eq valid_coordinate
      end
    end

    context 'when given invalid input' do
      let(:invalid_input) { "foo" }

      it 'prompts the user until given valid input' do
        $stdin.string = invalid_input + "\n" + invalid_input + "\n" + valid_input
        cli.solicit_move(@default_first_player)

        expect(has_at_least_one_repeated_line?($stdout.string)).to be true
      end
    end
  end

  describe '#report_invalid_move' do

    it 'prints a notification that a move cannot be made at the given coordinates and why' do
      cli.report_invalid_move([0, 0], "reason")

      expect($stdout.string).to include "reason"
      expect($stdout.string.split("").count("0")).to eq 2
    end
  end

  describe '#report_move' do

    it 'prints a notification of the move made by the given mark at the given coordinates' do
      cli.report_move(@default_first_player, [0, 0])
      cli_output = $stdout.string

      expect(cli_output).to include @default_first_player.to_s
      expect(cli_output.split("").count("0")).to eq 2
    end
  end

  describe '#report_game_over' do

    context 'when given the mark of a winning player' do
      it 'prints a notification that the player has won' do
        expect(cli).to receive(:report_win).with(@default_first_player)
        cli.report_game_over(@default_first_player)
      end
    end

    context 'when winning player is ":none"' do
      it 'prints a notification that the game has ended in a draw' do
        expect(cli).to receive(:report_draw)
        cli.report_game_over(:none)
      end
    end
  end

  describe '#report_win' do

    it 'prints a notification that the player using the given mark has won' do
      cli.report_win(@default_first_player)
      cli_output = $stdout.string

      expect(cli_output).to include @default_first_player.to_s
      expect(cli_output).to include "wins"
    end
  end

  describe '#report_draw' do

    it 'prints a notification that the game has ended in a draw' do
      cli.report_draw

      expect($stdout.string).to include "draw"
    end
  end
end