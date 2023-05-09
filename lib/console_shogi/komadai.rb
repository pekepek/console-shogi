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

    def put(piece:)
      index = pieces.index(&:none?)

      raise NoSpaceError if index.nil?

      @pieces[*index] = piece

      column_num = pieces.count / 3
      @pieces = Matrix.rows(pieces.sort_by {|p| -p.number }.each_slice(column_num).to_a)
    end

    private

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
