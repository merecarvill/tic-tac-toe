require 'spec_helper'

describe TicTacToe::ComputerPlayer do

  it 'implements PlayerInterface' do
    TicTacToe::PlayerInterface.required_methods.each do |method|
      expect(described_class.new).to respond_to(method)
    end
  end
end