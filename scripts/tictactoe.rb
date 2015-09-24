$:.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))

require "game"

TicTacToe::Game.new({}).run