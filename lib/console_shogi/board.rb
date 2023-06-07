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

    def deep_copy
      Board.new(pieces: pieces.map(&:dup).to_a)
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

    def promote_piece!(x:, y:)
      @pieces[y, x] = pieces[y, x].promote
    end

    def put_piece!(piece:, to:)
      @pieces[to[:y], to[:x]] = piece
    end

    def move_piece!(from:, to:)
      @pieces[to[:y], to[:x]] = @pieces[from[:y], from[:x]]
      @pieces[from[:y], from[:x]] = NonePiece.new
    end

    private

    attr_reader :pieces
  end
end
