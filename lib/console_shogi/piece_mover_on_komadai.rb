# frozen_string_literal: true

module ConsoleShogi
  class PieceMoverOnKomadai
    def initialize(board:, komadai:, from:, to:)
      @board = board
      @komadai = komadai
      # 駒台の index に直す必要がある
      @from = from
      @to = to
    end

    def drop!
      return if from_piece.nil? || from_piece.none?

      return if to[:location] != :board
      return unless can_drop?(piece: from_piece, to: to)

      komadai.pick_up_piece!(from: from)
      board.put_piece!(piece: from_piece, to: to)
    end

    private

    attr_reader :board, :komadai, :from, :to

    def from_piece
      @from_piece ||= komadai.fetch_piece(x: from[:x], y: from[:y])
    end

    def can_drop?(piece:, to:)
      to_piece = board.fetch_piece(x: to[:x], y: to[:y])

      return false unless to_piece.none?

      return false if nifu?(piece, to)

      can_move_next_turn?(piece, to)
    end

    def can_move_next_turn?(piece, to)
      piece.moves.any? {|m|
        PieceMover.new(board: board, from: to, to: {x: to[:x] + m[:x], y: to[:y] + m[:y]}).can_move?
      }
    end

    def nifu?(piece, to)
      piece.fu? &&
        board.matrix.column(to[:x]).any? {|p| p.fu? && piece.player == p.player }
    end
  end
end
