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

      Terminal::Drawer.clear_scrren
      Terminal::Drawer.print_board(board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)
      Terminal::Drawer.print_history_button
      Terminal::Drawer.print_teban(teban_player.teban)
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

          # TODO 選択したピースは色を変えないようにしている。状態の持ち方を見直したい
          deactive_piece(teminal.last_cursor_on_grid) if teminal.selected_cursor&.grid_position != teminal.last_cursor_on_grid.grid_position
          focus_piece(teminal.cursor) if teminal.selected_cursor&.grid_position != teminal.cursor.grid_position
        # NOTE Enter を押したら駒を移動
        elsif key == "\r"
          if teminal.cursor.grid_position.location.history?
            GameHistory.new(game_histories: game_histories).start

            next
          end

          if teminal.selected_cursor.nil?
            # TODO PieceMover の can_move? と分散してしまっている気もする
            next if teminal.cursor.grid_position.location.outside?

            active_piece(teminal.cursor)

            teminal.select_cursor!
          else
            next unless teminal.cursor.grid_position.location.board?

            piece_mover = PieceMover.build(board: board, player: teban_player, from_cursor: teminal.selected_cursor, to_cursor: teminal.cursor)

            piece_mover.move!

            if piece_mover.moved_piece?
              Terminal::Drawer.print_diff_board(previous_board: game_histories.last[:board], board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)

              @game_histories << {board: board.deep_copy, sente_komadai: sente_player.komadai.deep_copy, gote_komadai: gote_player.komadai.deep_copy}

              if teban_player.win?
                Terminal::Drawer.print_winner(teban_player)

                exit
              else
                change_teban!

                Terminal::Drawer.print_teban(teban_player.teban)
              end
            else
              deactive_piece(teminal.selected_cursor)
            end

            teminal.deselect_cursor!
          end
        end
      end
    end

    private

    attr_reader :board, :sente_player, :gote_player, :teminal, :teban_player, :game_histories

    def change_teban!
      @teban_player = teban_player == sente_player ? gote_player : sente_player
    end

    # TODO ここらへんイケてないのでリファクタしたい
    def active_piece(cursor)
      location = fetch_piece_location_object(cursor.grid_position.location)

      return if location.nil?

      Terminal::Drawer.active_piece(board: location, cursor: cursor)
    end

    def deactive_piece(cursor)
      location = fetch_piece_location_object(cursor.grid_position.location)

      return if location.nil?

      Terminal::Drawer.deactive_piece(board: location, previous_cursor: cursor)
    end

    def focus_piece(cursor)
      location = fetch_piece_location_object(cursor.grid_position.location)

      return if location.nil?

      Terminal::Drawer.focus_piece(board: location, cursor: cursor)
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
