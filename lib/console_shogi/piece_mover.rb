# frozen_string_literal: true

module ConsoleShogi
  class PieceMover
    def initialize(board:, from:)
      @board = board
      @from_piece_index = from
    end

    def move
      return if target_piece.nil? || target_piece.none?

      while key = STDIN.getch
        if key == "\e" && STDIN.getch == "["
          key = STDIN.getch

          TerminalOperator.move_cursor(key)
        elsif key == "\r"
          to_piece_index = TerminalOperator.squares_index

          return unless can_move?(piece: target_piece, from: from_piece_index, to: to_piece_index)

          board.change_piece!(
            from: {x: from_piece_index[:x], y: from_piece_index[:y]},
            to: {x: to_piece_index[:x], y: to_piece_index[:y]}
          )

          return
        end
      end
    end

    private

    attr_reader :board, :from_piece_index

    def target_piece
      @target_piece ||= board.fetch_piece(x: from_piece_index[:x], y: from_piece_index[:y])
    end

    def can_move?(piece:, from:, to:)
      diff = {x: to[:x] - from[:x], y: to[:y] - from[:y]}

      return false if piece.moves.none? {|m| m[:x] == diff[:x] && m[:y] == diff[:y] }

      to_piece = board.fetch_piece(x: to[:x], y: to[:y])

      return false if piece.player.teban == to_piece.player.teban

      return true unless piece.kaku? || piece.hisha? || piece.kyosha?

      distance = (diff[:x].nonzero? || diff[:y]).abs
      element = [diff[:x] / distance, diff[:y] / distance]

      1.upto(distance - 1) do |d|
        piece = board.fetch_piece(x: from[:x] + element[0] * d, y: from[:y] + element[1] * d)

        return false unless piece.none?
      end

      true
    end
  end
end
