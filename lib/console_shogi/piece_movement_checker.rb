# frozen_string_literal: true

module ConsoleShogi
  class PieceMovementChecker
    def initialize(board:, from:, to:)
      @board = board
      @from = from
      @to = to
    end

    def can_move?
      return false unless board.within_range?(row: to[:row], column: to[:column])

      diff = {row: to[:row] - from[:row], column: to[:column] - from[:column]}

      return false if from_piece.moves.none? {|m| m[:row] == diff[:row] && m[:column] == diff[:column] }

      return false if from_piece.teban == to_piece.teban

      return true unless from_piece.can_move_long_distance?

      distance = (diff[:row].nonzero? || diff[:column]).abs
      element = [diff[:row] / distance, diff[:column] / distance]

      1.upto(distance - 1) do |d|
        piece = board.fetch_piece(row: from[:row] + element[0] * d, column: from[:column] + element[1] * d)

        return false unless piece.none?
      end

      true
    end

    private

    attr_reader :board, :from, :to

    def from_piece
      @from_piece ||= board.fetch_piece(row: from[:row], column: from[:column])
    end

    def to_piece
      @to_piece ||= board.fetch_piece(row: to[:row], column: to[:column])
    end
  end
end
