require 'spec_helper'

describe TicTacToe::PlayerInterface do
  let(:interface_error) {TicTacToe::PlayerInterface::InterfaceError}

  describe '.requred_methods' do

    it 'provides the name of each method that must be implemented' do
      [:move].each do |method|
        expect(described_class.required_methods.include?(method)).to be true
      end
    end
  end

  describe '#move' do

    it 'raises error if not implemented by subclass' do
      expect{described_class.new.move}.to raise_error(interface_error, /\w*/)
    end
  end
end