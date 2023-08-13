# frozen_string_literal: true

require_relative 'terminal/display_area'
require_relative 'terminal/drawer'
require_relative 'terminal/cursor'

module ConsoleShogi
  class Terminal
    attr_reader :cursor, :drawer, :selected_cursor, :last_cursor_on_grid

    def initialize
      @cursor = Cursor.new
      @drawer = Drawer.new

      @selected_cursor = nil
      @last_cursor_on_grid = nil
    end

    def move_cursor!(key)
      @last_cursor_on_grid = cursor.dup unless cursor.grid_position.location.outside?

      cursor.move!(key)

      drawer.move_cursor(cursor)
    end

    def select_cursor!(piece)
      active_piece(piece)

      @selected_cursor = cursor.dup
    end

    def deselect_cursor!(piece)
      deactive_piece(piece, selected_cursor)

      @selected_cursor = nil
    end

    def init_scrren(board:, sente_komadai:, gote_komadai:)
      drawer.clear_scrren
      drawer.print_board(board: board, sente_komadai: sente_komadai, gote_komadai: gote_komadai)
      drawer.print_history_button
      drawer.print_teban(Teban::SENTE)

      drawer.move_cursor(cursor)
    end

    def print_diff_board(previous_board:, board:, sente_komadai:, gote_komadai:)
      drawer.print_diff_board(previous_board: previous_board, board: board, sente_komadai: sente_komadai, gote_komadai: gote_komadai)

      drawer.move_cursor(cursor)
    end

    def print_winner(winner)
      drawer.print_winner(winner)
    end

    def print_teban(teban)
      drawer.print_teban(teban)
    end

    def active_piece(piece)
      return if piece.nil?

      drawer.active_piece(piece: piece)
      drawer.move_cursor(cursor)
    end

    def deactive_piece(piece, piece_cursor)
      return if piece.nil?

      drawer.deactive_piece(piece: piece, cursor: piece_cursor)
      drawer.move_cursor(cursor)
    end

    def focus_piece(piece)
      return if piece.nil?

      drawer.focus_piece(piece: piece)
      drawer.move_cursor(cursor)
    end
  end
end
