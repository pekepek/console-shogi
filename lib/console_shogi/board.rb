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

    def fetch_piece(x:, y:)
      @pieces[y, x]
    end

    def change_piece(from:, to:)
      from_piece = @pieces[from[:y], from[:x]]
      diff = {x: to[:x] - from[:x], y: to[:y] - from[:y]}

      return if from_piece.moves.none? {|m| m[:x] == diff[:x] && m[:y] == diff[:y] }

      @pieces[from[:y], from[:x]] = @pieces[to[:y], to[:x]]
      @pieces[to[:y], to[:x]] = from_piece
    end

    private

    attr_reader :pieces
  end
end
