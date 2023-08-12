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

    def within_range?(row:, column:)
      case {row: row, column: column}
      in row: 0..8, column: 0..8
        true
      else
        false
      end
    end

    def fetch_piece(row:, column:)
      pieces[column, row]
    end

    def promote_piece!(row:, column:)
      @pieces[column, row] = pieces[column, row].promote
    end

    def put_piece!(piece:, to:)
      @pieces[to[:column], to[:row]] = piece
    end

    def move_piece!(from:, to:)
      @pieces[to[:column], to[:row]] = @pieces[from[:column], from[:row]]
      @pieces[from[:column], from[:row]] = NonePiece.new
    end

    private

    attr_reader :pieces
  end
end
