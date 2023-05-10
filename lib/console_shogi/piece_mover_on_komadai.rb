# frozen_string_literal: true

module ConsoleShogi
  class PieceMoverOnKomadai
    def initialize(board:, komadai:, from:)
      @board = board
      @komadai = komadai
      # 駒台の index に直す必要がある
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

          return if to_piece_index[:location] != :board
          return unless can_move?(piece: target_piece, from: from_piece_index, to: to_piece_index)

          komadai.pick_up_piece!(from: from_piece_index)
          board.put_piece!(piece: target_piece, to: to_piece_index)

          return
        end
      end
    end

    private

    attr_reader :board, :komadai, :from_piece_index

    def target_piece
      @target_piece ||= komadai.fetch_piece(x: from_piece_index[:x], y: from_piece_index[:y])
    end

    def can_move?(piece:, from:, to:)
      to_piece = board.fetch_piece(x: to[:x], y: to[:y])

      return false unless to_piece.none?

      # ピースが動かせる場所があるか
      true
    end
  end
end
