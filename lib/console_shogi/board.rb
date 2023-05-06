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
      pieces[y, x]
    end

    def change_piece(from:, to:)
      from_piece = pieces[from[:y], from[:x]]

      return unless can_move?(piece: from_piece, from: from, to: to)

      @pieces[from[:y], from[:x]] = pieces[to[:y], to[:x]]
      @pieces[to[:y], to[:x]] = from_piece
    end

    def can_move?(piece:, from:, to:)
      diff = {x: to[:x] - from[:x], y: to[:y] - from[:y]}

      return false if piece.moves.none? {|m| m[:x] == diff[:x] && m[:y] == diff[:y] }

      to_piece = pieces[to[:y], to[:x]]

      return false if piece.player == to_piece.player

      return true unless piece.kaku? || piece.hisha? || piece.kyosha?

      distance = (diff[:x].nonzero? || diff[:y]).abs
      element = [diff[:x] / distance, diff[:y] / distance]

      1.upto(distance - 1) do |d|
        piece = fetch_piece(x: from[:x] + element[0] * d, y: from[:y] + element[1] * d)

        return false unless piece.none?
      end

      true
    end

    private

    attr_reader :pieces
  end
end
