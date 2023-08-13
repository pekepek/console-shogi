# frozen_string_literal: true

require 'io/console'

module ConsoleShogi
  class Game
    def initialize
      @sente_player = Player.new(teban: Teban::SENTE)
      @gote_player = Player.new(teban: Teban::GOTE)
      @board = NewBoardBuilder.build
      @teminal = Terminal.new

      @teban_player = @sente_player

      @game_histories = [{board: board.deep_copy, sente_komadai: sente_player.komadai.deep_copy, gote_komadai: gote_player.komadai.deep_copy}]

      teminal.init_scrren(board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)
    end

    def start
      while key = STDIN.getch
        # NOTE Ctrl-C を押したら終了
        if key == "\C-c"
          exit
        # NOTE 矢印キーを押したらカーソルを移動
        elsif key == "\e" && STDIN.getch == "["
          key = STDIN.getch

          teminal.move_cursor!(key)

          piece = fetch_piece(teminal.last_cursor_on_grid)

          # TODO イケてない直す
          unless teminal.selected_cursor&.same_position?(teminal.last_cursor_on_grid)
            piece = fetch_piece(teminal.last_cursor_on_grid)
            teminal.deactive_piece(piece, teminal.last_cursor_on_grid)
          end

          unless teminal.selected_cursor&.same_position?(teminal.cursor)
            piece = fetch_piece(teminal.cursor)
            teminal.focus_piece(piece)
          end
        # NOTE Enter を押したら駒を移動
        elsif key == "\r"
          if teminal.cursor.grid_position.location.history?
            # TODO 一旦 History は使えなくする。棋譜で履歴を遡れるように変更する。
            # GameHistory.new(game_histories: game_histories).start

            next
          end

          if teminal.selected_cursor.nil?
            piece = fetch_piece(teminal.cursor)
            teminal.select_cursor!(piece)
          else
            next unless teminal.cursor.grid_position.location.board?

            piece_mover = PieceMover.build(board: board, player: teban_player, from_cursor: teminal.selected_cursor, to_cursor: teminal.cursor)

            piece_mover.move!

            if piece_mover.moved_piece?
              teminal.print_diff_board(previous_board: game_histories.last[:board], board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)

              @game_histories << {board: board.deep_copy, sente_komadai: sente_player.komadai.deep_copy, gote_komadai: gote_player.komadai.deep_copy}

              if teban_player.win?
                teminal.print_winner(teban_player)

                exit
              else
                change_teban!

                teminal.print_teban(teban_player.teban)
              end
            end

            piece = fetch_piece(teminal.selected_cursor)
            teminal.deselect_cursor!(piece)
          end
        end
      end
    end

    private

    attr_reader :board, :sente_player, :gote_player, :teminal, :teban_player, :game_histories

    def change_teban!
      @teban_player = teban_player == sente_player ? gote_player : sente_player
    end

    def fetch_piece(cursor)
      return if cursor.grid_position.location.outside?

      piece_location = fetch_piece_location_object(cursor.grid_position.location)
      piece = piece_location.fetch_piece(row: cursor.grid_position.row, column: cursor.grid_position.column)
    end

    def fetch_piece_location_object(cursor_location)
      case cursor_location.name
      when :board
        board
      when :sente_komadai
        sente_player.komadai
      when :gote_komadai
        gote_player.komadai
      end
    end
  end
end
