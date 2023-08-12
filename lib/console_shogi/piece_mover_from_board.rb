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
      @from_piece ||= board.fetch_piece(x: from.x, y: from.y)
    end

    def move_piece!
      return false if from_piece.nil? || from_piece.none?
      return false if from_piece.teban != player.teban

      return false unless piece_movement_checker.can_move?

      to_piece = board.fetch_piece(x: to.x, y: to.y)
      player.capture_piece!(to_piece) unless to_piece.none?

      board.move_piece!(
        from: {x: from.x, y: from.y},
        to: {x: to.x, y: to.y}
      )

      # TODO とりあえずここに実装してしまっている。整理したい
      return true unless can_promote?(from_piece, from, to)

      board.promote_piece!(x: to.x, y: to.y) if Terminal::Drawer.select_promotion

      true
    end

    def piece_movement_checker
      PieceMovementChecker.new(board: board, from: from, to: to)
    end

    def can_promote?(piece, from, to)
      return false unless piece.can_promote?

      if piece.teban == Teban::SENTE
        from.y.between?(0, 2) || to.y.between?(0, 2)
      elsif piece.teban == Teban::GOTE
        from.y.between?(6, 8) || to.y.between?(6, 8)
      end
    end
  end
end
