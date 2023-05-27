# frozen_string_literal: true

module ConsoleShogi
  class PieceMover
    def initialize(board:, from:, to:)
      @board = board
      @from = from
      @to = to
      @moved_piece = false
    end

    def move!
      @moved_piece = move_piece!
    end

    def moved_piece?
      @moved_piece
    end

    def can_move?
      return false unless board.within_range?(x: to[:x], y: to[:y])

      diff = {x: to[:x] - from[:x], y: to[:y] - from[:y]}

      return false if from_piece.moves.none? {|m| m[:x] == diff[:x] && m[:y] == diff[:y] }

      to_piece = board.fetch_piece(x: to[:x], y: to[:y])

      return false if from_piece.player.teban == to_piece.player.teban

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

    def move_piece!
      return false if from_piece.nil? || from_piece.none?

      return false unless can_move?

      board.move_piece!(
        from: {x: from[:x], y: from[:y]},
        to: {x: to[:x], y: to[:y]}
      )

      # TODO とりあえずここに実装してしまっている。整理したい
      piece = board.fetch_piece(x: to[:x], y: to[:y])
      return true unless can_promote?(piece, from, to)

      board.promote_piece!(x: to[:x], y: to[:y]) if TerminalOperator.select_promotion

      true
    end

    def from_piece
      @from_piece ||= board.fetch_piece(x: from[:x], y: from[:y])
    end

    def can_promote?(piece, from, to)
      return false unless piece.can_promote?

      if piece.player.sente?
        from[:y].between?(0, 2) || to[:y].between?(0, 2)
      elsif piece.player.gote?
        from[:y].between?(6, 8) || to[:y].between?(6, 8)
      end
    end
  end
end
