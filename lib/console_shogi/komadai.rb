# frozen_string_literal: true

require 'matrix'

module ConsoleShogi
  class Komadai
    class NoSpaceError < StandardError; end

    attr_reader :pieces

    def initialize
      @pieces = empty_pieces
    end

    def expand!
      @pieces = pieces.hstack(empty_pieces)
    end

    def have_space?
      pieces.any?(&:none?)
    end

    def fetch_piece(x:, y:)
      pieces[y, x]
    end

    def put(piece:)
      index = pieces.index(&:none?)

      raise NoSpaceError if index.nil?

      @pieces[*index] = piece

      @pieces = sort_pieces
    end

    def pick_up_piece!(from:)
      @pieces[from[:y], from[:x]] = NonePiece.new
      @pieces = sort_pieces
    end

    private

    def sort_pieces
      column_num = pieces.count / 3
      Matrix.rows(pieces.sort_by {|p| -p.number }.each_slice(column_num).to_a)
    end

    def empty_pieces
      Matrix.rows(
        [
          [NonePiece.new, NonePiece.new, NonePiece.new],
          [NonePiece.new, NonePiece.new, NonePiece.new],
          [NonePiece.new, NonePiece.new, NonePiece.new]
        ]
      )
    end
  end
end
