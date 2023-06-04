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

          @last_cursor_on_grid = cursor.dup unless cursor.grid_position.location == :others

          cursor.move(key)

          # TODO 選択したピースは色を変えないようにしている。状態の持ち方を見直したい
          deactive_piece(last_cursor_on_grid) if selected_cursor&.grid_position != last_cursor_on_grid.grid_position
          focus_piece(cursor) if selected_cursor&.grid_position != cursor.grid_position
        # NOTE Enter を押したら駒を移動
        elsif key == "\r"
          if selected_cursor.nil?
            # TODO PieceMover の can_move? と分散してしまっている気もする
            next if cursor.grid_position.location == :others

            active_piece(cursor)

            @selected_cursor = cursor.dup
          else
            next if cursor.grid_position.location != :board

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

    def active_piece(cursor)
      # TODO case で指定しないといけないのイケてないのでリファクタしたい
      case cursor.grid_position.location
      when :board
        Terminal::Operator.active_piece(location: board, cursor: cursor)
      when :sente_komadai
        Terminal::Operator.active_piece(location: sente_player.komadai, cursor: cursor)
      when :gote_komadai
        Terminal::Operator.active_piece(location: gote_player.komadai, cursor: cursor)
      end
    end

    def deactive_piece(cursor)
      # TODO case で指定しないといけないのイケてないのでリファクタしたい
      case cursor.grid_position.location
      when :board
        Terminal::Operator.deactive_piece(location: board, previous_cursor: cursor)
      when :sente_komadai
        Terminal::Operator.deactive_piece(location: sente_player.komadai, previous_cursor: cursor)
      when :gote_komadai
        Terminal::Operator.deactive_piece(location: gote_player.komadai, previous_cursor: cursor)
      end
    end

    def focus_piece(cursor)
      # TODO case で指定しないといけないのイケてないのでリファクタしたい
      case cursor.grid_position.location
      when :board
        Terminal::Operator.focus_piece(location: board, cursor: cursor)
      when :sente_komadai
        Terminal::Operator.focus_piece(location: sente_player.komadai, cursor: cursor)
      when :gote_komadai
        Terminal::Operator.focus_piece(location: gote_player.komadai, cursor: cursor)
      end
    end
  end
end
