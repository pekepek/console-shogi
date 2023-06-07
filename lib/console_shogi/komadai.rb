# frozen_string_literal: true

require 'matrix'

module ConsoleShogi
  class Komadai
    class NoSpaceError < StandardError; end

    attr_reader :pieces

    def initialize(pieces: empty_pieces)
      @pieces = Matrix.rows(pieces)
    end

    def deep_copy
      Komadai.new(pieces: pieces.map(&:dup).to_a)
    end

    def fetch_piece(x:, y:)
      pieces[y, x]
    end

    def put(piece:)
      expand! unless have_space?

      index = pieces.index(&:none?)

      piece = piece.original if piece.promoted?

      @pieces[*index] = piece

      @pieces = sort_pieces
    end

    def pick_up_piece!(x:, y:)
      @pieces[y, x] = NonePiece.new
      @pieces = sort_pieces
    end

    private

    def expand!
      @pieces = pieces.hstack(empty_pieces)
    end

    def have_space?
      pieces.any?(&:none?)
    end

    def sort_pieces
      column_num = pieces.count / 3
      Matrix.rows(pieces.sort_by {|p| -p.number }.each_slice(column_num).to_a)
    end

    def empty_pieces
      [
        [NonePiece.new, NonePiece.new, NonePiece.new],
        [NonePiece.new, NonePiece.new, NonePiece.new],
        [NonePiece.new, NonePiece.new, NonePiece.new]
      ]
    end
  end
end
