require 'spec_helper'

describe TicTacToe::PlayerInterface do
  let(:interface_error) {TicTacToe::PlayerInterface::InterfaceError}

  describe '.requred_methods' do

    it 'provides the name of each method that must be implemented' do
      methods = [:move]
      methods.each do |method|
        expect(described_class.required_methods.include?(method)).to be true
      end
      expect(described_class.required_methods - methods).to eq []
    end
  end

  describe '#move' do

    it 'raises error if not implemented by subclass' do
      expect{described_class.new.move}.to raise_error(interface_error, /\w*/)
    end
  end
end