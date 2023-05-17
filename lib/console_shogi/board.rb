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

    def within_range?(x:, y:)
      case {x: x, y: y}
      in x: 0..8, y: 0..8
        true
      else
        false
      end
    end

    def fetch_piece(x:, y:)
      pieces[y, x]
    end

    def put_piece!(piece:, to:)
      @pieces[to[:y], to[:x]] = piece
    end

    def move_piece!(from:, to:)
      from_piece = @pieces[from[:y], from[:x]]
      @pieces[from[:y], from[:x]] = NonePiece.new

      to_piece = @pieces[to[:y], to[:x]]

      # NOTE 駒を取る、リファクタする
      #      from_piece.player で player 取るの違和感
      from_piece.player.capture_piece!(to_piece) unless to_piece.none?

      # NOTE だいぶ複雑になってきている、整理して外に出したい
      @pieces[to[:y], to[:x]] =
        if can_promote?(from_piece, to)
          from_piece.promote
        else
          from_piece
        end
    end

    private

    attr_reader :pieces

    def can_promote?(piece, to)
      (piece.player.sente? && to[:y].between?(0, 2)) ||
        (piece.player.gote? && to[:y].between?(6, 8))
    end
  end
end
