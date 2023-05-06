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

    def change_piece(from:, to:)
      t = @pieces[*to]
      @pieces[*to] = @pieces[*from]
      @pieces[*from] = t
    end

    private

    attr_reader :pieces
  end
end
