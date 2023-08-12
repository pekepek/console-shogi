# frozen_string_literal: true

module ConsoleShogi
  class PieceMoverFromKomadai < PieceMover
    def initialize(board:, player:, from:, to:)
      @board = board
      @komadai = player.komadai
      @player = player
      @from = from
      @to = to
      @moved_piece = false
    end

    private

    attr_reader :board, :komadai, :player, :from, :to

    def move_piece!
      return false if from_piece.nil? || from_piece.none?
      return false if from_piece.teban != player.teban

      return false unless to.location.board?
      return false unless can_drop?(piece: from_piece, to: to)

      komadai.pick_up_piece!(row: from.row, column: from.column)
      board.put_piece!(piece: from_piece, to: to)

      true
    end

    def from_piece
      @from_piece ||= komadai.fetch_piece(row: from.row, column: from.column)
    end

    def can_drop?(piece:, to:)
      to_piece = board.fetch_piece(row: to.row, column: to.column)

      return false unless to_piece.none?

      return false if nifu?(piece, to)

      # TODO 動かせない場所に打つことはできないようにする
      true
    end

    def nifu?(piece, to)
      piece.fu? &&
        board.matrix.column(to.row).any? {|p| p.fu? && piece.teban == p.teban }
    end
  end
end
