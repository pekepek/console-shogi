# frozen_string_literal: true

require 'matrix'

module ConsoleShogi
  class Board
    def initialize
      @pieces = Matrix.rows(Boards::NEW_BOARD)
    end

    def matrix
      @pieces
    end
  end
end
