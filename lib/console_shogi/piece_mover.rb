# frozen_string_literal: true

module ConsoleShogi
  class PieceMover
    def initialize(board:, from:)
      @board = board
      @from_piece_index = from
    end

    def move!
      return if target_piece.nil? || target_piece.none?

      while key = STDIN.getch
        if key == "\e" && STDIN.getch == "["
          key = STDIN.getch

          TerminalOperator.move_cursor(key)
        elsif key == "\r"
          to_piece_index = TerminalOperator.squares_index

          return unless can_move?(piece: target_piece, to_piece_index: to_piece_index)

          board.move_piece!(
            from: {x: from_piece_index[:x], y: from_piece_index[:y]},
            to: {x: to_piece_index[:x], y: to_piece_index[:y]}
          )

          # TODO とりあえずここに実装してしまっている。整理したい
          piece = board.fetch_piece(x: to_piece_index[:x], y: to_piece_index[:y])
          return unless can_promote?(piece, to_piece_index)

          board.promote_piece!(x: to_piece_index[:x], y: to_piece_index[:y]) if TerminalOperator.select_promotion

          return
        end
      end
    end

    def can_move?(piece:, to_piece_index:)
      return false unless board.within_range?(x: to_piece_index[:x], y: to_piece_index[:y])

      diff = {x: to_piece_index[:x] - from_piece_index[:x], y: to_piece_index[:y] - from_piece_index[:y]}

      return false if piece.moves.none? {|m| m[:x] == diff[:x] && m[:y] == diff[:y] }

      to_piece = board.fetch_piece(x: to_piece_index[:x], y: to_piece_index[:y])

      return false if piece.player.teban == to_piece.player.teban

      return true unless piece.kaku? || piece.hisha? || piece.kyosha?

      distance = (diff[:x].nonzero? || diff[:y]).abs
      element = [diff[:x] / distance, diff[:y] / distance]

      1.upto(distance - 1) do |d|
        piece = board.fetch_piece(x: from_piece_index[:x] + element[0] * d, y: from_piece_index[:y] + element[1] * d)

        return false unless piece.none?
      end

      true
    end

    private

    attr_reader :board, :from_piece_index

    def target_piece
      @target_piece ||= board.fetch_piece(x: from_piece_index[:x], y: from_piece_index[:y])
    end

    def can_promote?(piece, to)
      piece.can_promote? &&
      (piece.player.sente? && to[:y].between?(0, 2)) ||
        (piece.player.gote? && to[:y].between?(6, 8))
    end
  end
end
