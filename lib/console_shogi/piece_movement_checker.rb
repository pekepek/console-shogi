# frozen_string_literal: true

module ConsoleShogi
  class PieceMovementChecker
    def initialize(board:, from:, to:)
      @board = board
      @from = from
      @to = to
    end

    def can_move?
      return false unless board.within_range?(x: to[:x], y: to[:y])

      diff = {x: to[:x] - from[:x], y: to[:y] - from[:y]}

      return false if from_piece.moves.none? {|m| m[:x] == diff[:x] && m[:y] == diff[:y] }

      return false if from_piece.teban == to_piece.teban

      return true unless from_piece.can_move_long_distance?

      distance = (diff[:x].nonzero? || diff[:y]).abs
      element = [diff[:x] / distance, diff[:y] / distance]

      1.upto(distance - 1) do |d|
        piece = board.fetch_piece(x: from[:x] + element[0] * d, y: from[:y] + element[1] * d)

        return false unless piece.none?
      end

      true
    end

    private

    attr_reader :board, :from, :to

    def from_piece
      @from_piece ||= board.fetch_piece(x: from[:x], y: from[:y])
    end

    def to_piece
      @to_piece ||= board.fetch_piece(x: to[:x], y: to[:y])
    end
  end
end
