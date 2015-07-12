module TicTacToe
  class PlayerInterface
    InterfaceError = Class.new(StandardError)

    def self.required_methods
      [:move]
    end

    def move
      raise InterfaceError, "#{self.class}#move is not implemented"
    end
  end
end