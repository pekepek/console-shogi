# frozen_string_literal: true

require 'io/console'

module ConsoleShogi
  class Game
    def initialize
      @sente_player = Player.new(teban: Teban::SENTE)
      @gote_player = Player.new(teban: Teban::GOTE)
      @board = NewBoardBuilder.build

      @previous_board = Board.new(pieces: [])
      @selected_cursor = nil
      @teban_player = @sente_player

      Terminal::Operator.clear_scrren
      Terminal::Operator.print_diff_board(previous_board: previous_board, board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)
      Terminal::Operator.print_history_button
      Terminal::Operator.print_teban(teban_player.teban)
    end

    def start
      while key = STDIN.getch
        cursor = Terminal::Operator.cursor

        # NOTE Ctrl-C を押したら終了
        if key == "\C-c"
          exit
        # NOTE 矢印キーを押したらカーソルを移動
        elsif key == "\e" && STDIN.getch == "["
          key = STDIN.getch

          @last_cursor_on_grid = cursor.dup unless cursor.grid_position.location.outside?

          cursor.move(key)

          # TODO 選択したピースは色を変えないようにしている。状態の持ち方を見直したい
          deactive_piece(last_cursor_on_grid) if selected_cursor&.grid_position != last_cursor_on_grid.grid_position
          focus_piece(cursor) if selected_cursor&.grid_position != cursor.grid_position
        # NOTE Enter を押したら駒を移動
        elsif key == "\r"
          if selected_cursor.nil?
            # TODO PieceMover の can_move? と分散してしまっている気もする
            next if cursor.grid_position.location.outside?

            active_piece(cursor)

            @selected_cursor = cursor.dup
          else
            next unless cursor.grid_position.location.board?

            piece_mover = PieceMover.build(board: board, player: teban_player, from_cursor: selected_cursor, to_cursor: cursor)

            piece_mover.move!

            if piece_mover.moved_piece?
              Terminal::Operator.print_diff_board(previous_board: previous_board, board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)

              @previous_board = board.copy

              if teban_player.win?
                Terminal::Operator.print_winner(teban_player)

                exit
              else
                change_teban!

                Terminal::Operator.print_teban(teban_player.teban)
              end
            else
              deactive_piece(selected_cursor)
            end

            @selected_cursor = nil
          end
        end
      end
    end

    private

    attr_reader :board, :sente_player, :gote_player, :selected_cursor, :teban_player, :previous_board, :last_cursor_on_grid

    def change_teban!
      @teban_player = teban_player == sente_player ? gote_player : sente_player
    end

    # TODO ここらへんイケてないのでリファクタしたい
    def active_piece(cursor)
      location = fetch_piece_location_object(cursor.grid_position.location)

      return if location.nil?

      Terminal::Operator.active_piece(board: location, cursor: cursor)
    end

    def deactive_piece(cursor)
      location = fetch_piece_location_object(cursor.grid_position.location)

      return if location.nil?

      Terminal::Operator.deactive_piece(board: location, previous_cursor: cursor)
    end

    def focus_piece(cursor)
      location = fetch_piece_location_object(cursor.grid_position.location)

      return if location.nil?

      Terminal::Operator.focus_piece(board: location, cursor: cursor)
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
