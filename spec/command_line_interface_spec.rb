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
  end
end