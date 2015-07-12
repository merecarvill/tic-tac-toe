require 'spec_helper'

describe TicTacToe::ComputerPlayer do
  shared_context "default_values"

  let(:ai_as_x) { described_class.new(:x) }

  it 'implements PlayerInterface' do
    TicTacToe::PlayerInterface.required_methods.each do |method|
      expect(ai_as_x).to respond_to(method)
    end
  end

  describe '#initialize' do

    it 'takes the player\'s mark' do
      mark = PLAYER_MARKS.shuffle
      expect(described_class.new(mark).mark).to eq mark
    end
  end
end