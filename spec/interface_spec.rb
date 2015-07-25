require 'spec_helper'

describe TicTacToe::Interface do

  describe '#intialize' do
    it 'takes the interface type' do
      expect{described_class.new(:command_line)}.not_to raise_error
    end
  end
end