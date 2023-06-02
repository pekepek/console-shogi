# frozen_string_literal: true

require 'io/console'

module ConsoleShogi
  class Game
    def initialize
      @sente_player = Player.new(teban: Teban::SENTE)
      @gote_player = Player.new(teban: Teban::GOTE)
      @board = NewBoardBuilder.build

      @previous_board = Board.new(pieces: [])
      @from_cursor = nil
      @selected_piece = false
      @teban_player = @sente_player
    end

    def start
      Terminal::Operator.clear_scrren

      Terminal::Operator.print_diff_board(previous_board: previous_board, board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)
      Terminal::Operator.print_teban(teban_player.teban)

      while key = STDIN.getch
        # NOTE Ctrl-C を押したら終了
        if key == "\C-c"
          exit
        # NOTE 矢印キーを押したらカーソルを移動
        elsif key == "\e" && STDIN.getch == "["
          key = STDIN.getch

          cursor = Terminal::Operator.cursor
          @previous_cursor_on_square = cursor.dup unless cursor.squares_position.location == :none

          cursor.move(key)

          # TODO 選択したピースは色を変えないようにしている。状態の持ち方を見直したい
          deactive_piece(previous_cursor_on_square) unless selected_piece && from_cursor.squares_position == previous_cursor_on_square.squares_position
          focus_piece(cursor) unless selected_piece && from_cursor.squares_position == cursor.squares_position
        # NOTE Enter を押したら駒を移動
        elsif key == "\r"
          # TODO このまま Hash にするかは要検討
          cursor = Terminal::Operator.cursor

          if selected_piece
            next if cursor.squares_position.location != :board

            piece_mover =
              case from_cursor.squares_position.location
              when :board
                # TODO 後で index を統一的にどう扱うか整理する
                PieceMover.new(
                  board: board,
                  player: teban_player,
                  from: from_cursor.squares_position.to_h,
                  to: cursor.squares_position.to_h
                )
              when :sente_komadai
                PieceMoverOnKomadai.new(
                  board: board,
                  komadai: sente_player.komadai,
                  from: from_cursor.squares_position.to_h,
                  to: cursor.squares_position.to_h
                )
              when :gote_komadai
                PieceMoverOnKomadai.new(
                  board: board,
                  komadai: gote_player.komadai,
                  from: from_cursor.squares_position.to_h,
                  to: cursor.squares_position.to_h
                )
              end

            piece_mover.move!

            if piece_mover.moved_piece?
              Terminal::Operator.print_diff_board(previous_board: previous_board, board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)

              @previous_board = board.copy
              change_teban!

              Terminal::Operator.print_teban(teban_player.teban)
            else
              deactive_piece(from_cursor)
            end

            @from_cursor = nil
            @selected_piece = false
          else
            # TODO PieceMover の can_move? と分散してしまっている気もする
            next if cursor.squares_position.location == :none
            next if teban_player.sente? && cursor.squares_position.location == :gote_komadai
            next if teban_player.gote? && cursor.squares_position.location == :sente_komadai

            active_piece(cursor)

            @from_cursor = cursor.dup
            @selected_piece = true
          end

          # TODO ひとまず動く物を作った。リファクタリングする
          [sente_player, gote_player].each do |player|
            next unless player.win?

            Terminal::Operator.print_winner(player)
            exit
          end
        end
      end
    end

    private

    attr_reader :board, :sente_player, :gote_player, :selected_piece, :from_cursor, :teban_player, :previous_board, :previous_cursor_on_square

    def change_teban!
      @teban_player = teban_player == sente_player ? gote_player : sente_player
    end

    def active_piece(cursor)
      # TODO case で指定しないといけないのイケてないのでリファクタしたい
      case cursor.squares_position.location
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
      case cursor.squares_position.location
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
      case cursor.squares_position.location
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
