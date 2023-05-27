# frozen_string_literal: true

module ConsoleShogi
  class PieceMoverOnKomadai
    def initialize(board:, komadai:, from:)
      @board = board
      @komadai = komadai
      # 駒台の index に直す必要がある
      @from_piece_index = from
    end

    def drop!
      return if target_piece.nil? || target_piece.none?

      while key = STDIN.getch
        if key == "\e" && STDIN.getch == "["
          key = STDIN.getch

          TerminalOperator.move_cursor(key)
        elsif key == "\r"
          to_piece_index = TerminalOperator.squares_index

          return if to_piece_index[:location] != :board
          return unless can_drop?(piece: target_piece, to_piece_index: to_piece_index)

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

    def can_drop?(piece:, to_piece_index:)
      to_piece = board.fetch_piece(x: to_piece_index[:x], y: to_piece_index[:y])

      return false unless to_piece.none?

      return false if nifu?(piece, to_piece_index)

      can_move_next_turn?(piece, to_piece_index)
    end

    def can_move_next_turn?(piece, to_piece_index)
      piece_mover = PieceMover.new(board: board, from: to_piece_index)

      piece.moves.any? {|m|
        piece_mover.can_move?(piece: piece, to_piece_index: {x: to_piece_index[:x] + m[:x], y: to_piece_index[:y] + m[:y]})
      }
    end

    def nifu?(piece, to_piece_index)
      piece.fu? &&
        board.matrix.column(to_piece_index[:x]).any? {|p| p.fu? && piece.teban == p.teban }
    end
  end
end
