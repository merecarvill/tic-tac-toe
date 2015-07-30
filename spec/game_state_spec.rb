require 'spec_helper'

module TicTacToe
  describe GameState do
    include_context 'default_values'
    include_context 'helper_methods'

    let(:starting_game_state) do
      described_class.new(
        board: new_board(@default_board_size),
        current_player: @default_first_player,
        opponent: @default_second_player)
    end

    describe '#initialize' do
      it 'takes a parameters hash with a game board, current player\'s mark, and opponent\'s mark' do
        params = {
          board: new_board(@default_board_size),
          current_player: @default_first_player,
          opponent: @default_second_player
        }

        expect { described_class.new(params) }.not_to raise_error
      end
    end

    describe '#make_move' do
      context 'when given coordinate is valid and board is blank at coordinate' do
        it 'returns a new game state object' do
          modified_game_state = starting_game_state.make_move(random_coordinates(@default_board_size))

          expect(modified_game_state).not_to eq starting_game_state
        end

        it 'creates a new board object to associate with the new game state' do
          modified_game_state = starting_game_state.make_move(random_coordinates(@default_board_size))

          expect(modified_game_state.board).not_to eq starting_game_state.board
        end

        it 'marks the new game state board with current player\'s mark at given coordinate' do
          coordinate = random_coordinates(@default_board_size)
          modified_game_state = starting_game_state.make_move(coordinate)

          expect(modified_game_state.board[*coordinate]).to eq starting_game_state.player_mark
        end

        it 'remembers the last move made in the new game state' do
          coordinate = random_coordinates(@default_board_size)
          modified_game_state = starting_game_state.make_move(coordinate)

          expect(modified_game_state.last_move).to eq coordinate
          expect(starting_game_state.last_move).not_to eq coordinate
        end

        it 'swaps the current player with the opponent in the new game state' do
          modified_game_state = starting_game_state.make_move(random_coordinates(@default_board_size))

          expect(modified_game_state.player_mark).to eq starting_game_state.opponent_mark
          expect(modified_game_state.opponent_mark).to eq starting_game_state.player_mark
        end
      end

      context 'when given coordinate is out of board\'s boundaries' do
        it 'raises an out of bounds board error' do
          bad_coordinate = [@default_board_size, @default_board_size]

          error_info = @out_of_bounds_error_info
          expect { starting_game_state.make_move(bad_coordinate) }.to raise_error(*error_info)
        end
      end

      context 'when board is not blank at given coordinate' do
        it 'raises a non-blank cell board error' do
          coordinate = random_coordinates(@default_board_size)
          modified_game_state = starting_game_state.make_move(coordinate)

          error_info = @non_empty_cell_error_info

          expect { modified_game_state.make_move(coordinate) }.to raise_error(*error_info)
        end
      end
    end
  end
end
