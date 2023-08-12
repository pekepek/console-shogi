# frozen_string_literal: true

module ConsoleShogi
  class PieceMoverFromBoard < PieceMover
    def initialize(board:, player:, from:, to:)
      @board = board
      @player = player
      @from = from
      @to = to
      @moved_piece = false
    end

    private

    attr_reader :board, :player, :from, :to

    def from_piece
      @from_piece ||= board.fetch_piece(row: from.row, column: from.column)
    end

    def move_piece!
      return false if from_piece.nil? || from_piece.none?
      return false if from_piece.teban != player.teban

      return false unless piece_movement_checker.can_move?

      to_piece = board.fetch_piece(row: to.row, column: to.column)
      player.capture_piece!(to_piece) unless to_piece.none?

      board.move_piece!(
        from: {row: from.row, column: from.column},
        to: {row: to.row, column: to.column}
      )

      # TODO とりあえずここに実装してしまっている。整理したい
      return true unless can_promote?(from_piece, from, to)

      board.promote_piece!(row: to.row, column: to.column) if Terminal::Drawer.select_promotion

      true
    end

    def piece_movement_checker
      PieceMovementChecker.new(board: board, from: from, to: to)
    end

    def can_promote?(piece, from, to)
      return false unless piece.can_promote?

      if piece.teban == Teban::SENTE
        from.column.between?(0, 2) || to.column.between?(0, 2)
      elsif piece.teban == Teban::GOTE
        from.column.between?(6, 8) || to.column.between?(6, 8)
      end
    end
  end
end
