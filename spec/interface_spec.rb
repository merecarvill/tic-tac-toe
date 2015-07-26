require 'spec_helper'

describe TicTacToe::Interface do
  include_context 'default_values'

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

  let(:cli) { described_class.new(:command_line) }

  describe '#intialize' do
    it 'takes the interface type' do
      expect{ described_class.new(:command_line) }.not_to raise_error
    end
  end

  describe '#game_setup_interaction' do
    it 'is implemented' do
      expect(cli.respond_to?(:game_setup_interaction)).to be true
    end
  end

  describe '#show_game_board' do
    it 'is implemented' do
      expect(cli.respond_to?(:show_game_board)).to be true
    end
  end
end