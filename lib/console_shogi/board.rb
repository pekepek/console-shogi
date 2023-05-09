# frozen_string_literal: true

require 'matrix'

module ConsoleShogi
  class Board
    def initialize(pieces:)
      @pieces = Matrix.rows(pieces)
    end

    def matrix
      @pieces
    end

    def fetch_piece(x:, y:)
      pieces[y, x]
    end

    def move_piece!(from:, to:)
      from_piece = @pieces[from[:y], from[:x]]
      @pieces[from[:y], from[:x]] = NonePiece.new

      to_piece = @pieces[to[:y], to[:x]]
      @pieces[to[:y], to[:x]] = from_piece

      return if to_piece.none?

      # NOTE 駒を取る、リファクタする
      #      from_piece.player で player 取るの違和感
      from_piece.player.capture_piece!(to_piece)
    end

    private

    attr_reader :pieces
  end
end
