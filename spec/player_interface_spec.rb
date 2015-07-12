require 'spec_helper'

describe TicTacToe::PlayerInterface do
  let(:interface_error) {TicTacToe::PlayerInterface::InterfaceError}

  describe '#move' do

    it 'raises error if not implemented by subclass' do
      expect{described_class.new.move}.to raise_error(interface_error, /\w*/)
    end
  end
end