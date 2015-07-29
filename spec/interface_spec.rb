require 'spec_helper'

module TicTacToe
  describe Interface do
    include_context 'default_values'

    before :all do
      $stdin = StringIO.new
      $stdout = StringIO.new
    end

    after do
      $stdin.string = ''
      $stdout.string = ''
    end

    after :all do
      $stdin = STDIN
      $stdout = STDOUT
    end

    let(:cli) { described_class.new(:command_line) }
    let(:interface_examples) { [cli] }
    let(:interface_error) { Interface::InterfaceError }

    describe '.requred_methods' do
      it 'provides the name of each method that must be implemented' do
        methods = [
          :game_setup_interaction,
          :show_game_board,
          :solicit_move,
          :report_invalid_move,
          :report_move,
          :report_game_over
        ]
        methods.each do |method|
          expect(described_class.required_methods.include?(method)).to be true
        end
        expect(described_class.required_methods - methods).to eq []
      end
    end

    describe '#intialize' do
      it 'takes the interface type' do
        expect { described_class.new(:command_line) }.not_to raise_error
      end

      context 'when given unrecognized player type' do
        it 'raises error' do
          expect { described_class.new(:invalid_type) }.to raise_error(interface_error)
        end
      end
    end

    describe '#game_setup_interaction' do
      it 'is implemented' do
        interface_examples.each do |interface|
          expect(interface.respond_to?(:game_setup_interaction)).to be true
        end
      end
    end

    describe '#show_game_board' do
      it 'is implemented' do
        interface_examples.each do |interface|
          expect(interface.respond_to?(:show_game_board)).to be true
        end
      end
    end

    describe '#solicit_move' do
      it 'is implemented' do
        interface_examples.each do |interface|
          expect(interface.respond_to?(:solicit_move)).to be true
        end
      end
    end

    describe '#report_invalid_move' do
      it 'is implemented' do
        interface_examples.each do |interface|
          expect(interface.respond_to?(:report_invalid_move)).to be true
        end
      end
    end

    describe '#report_move' do
      it 'is implemented' do
        interface_examples.each do |interface|
          expect(interface.respond_to?(:report_move)).to be true
        end
      end
    end

    describe '#report_game_over' do
      it 'is implemented' do
        interface_examples.each do |interface|
          expect(interface.respond_to?(:report_game_over)).to be true
        end
      end
    end
  end
end
