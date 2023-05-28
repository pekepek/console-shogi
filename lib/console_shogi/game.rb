# frozen_string_literal: true

require 'io/console'

module ConsoleShogi
  class Game
    def initialize
      @sente_player = Player.new(teban: Teban::SENTE)
      @gote_player = Player.new(teban: Teban::GOTE)
      @board = NewBoardBuilder.build

      @previous_board = Board.new(pieces: [])
      @from_index = nil
      @selected_piece = false
      @teban_player = @sente_player
    end

    def start
      TerminalOperator.clear_scrren

      TerminalOperator.print_diff_board(previous_board: previous_board, board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)
      TerminalOperator.print_teban(teban_player.teban)

      while key = STDIN.getch
        # NOTE Ctrl-C を押したら終了
        if key == "\C-c"
          exit
        # NOTE 矢印キーを押したらカーソルを移動
        elsif key == "\e" && STDIN.getch == "["
          key = STDIN.getch

          TerminalOperator.move_cursor(key)
        # NOTE Enter を押したら駒を移動
        elsif key == "\r"
          # TODO このまま Hash にするかは要検討
          index = TerminalOperator.squares_index

          if selected_piece
            next if index[:location] != :board

            piece_mover =
              case from_index[:location]
              when :board
                PieceMover.new(board: board, player: teban_player, from: from_index, to: index)
              when :sente_komadai
                PieceMoverOnKomadai.new(board: board, komadai: sente_player.komadai, from: from_index, to: index)
              when :gote_komadai
                PieceMoverOnKomadai.new(board: board, komadai: gote_player.komadai, from: from_index, to: index)
              end

            piece_mover.move!

            if piece_mover.moved_piece?
              TerminalOperator.print_diff_board(previous_board: previous_board, board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)

              @previous_board = board.copy
              change_teban!

              TerminalOperator.print_teban(teban_player.teban)
            end

            @from_index = nil
            @selected_piece = false
          else
            # TODO PieceMover の can_move? と分散してしまっている気もする
            next if index[:location] == :none
            next if teban_player.sente? && index[:location] == :gote_komadai
            next if teban_player.gote? && index[:location] == :sente_komadai

            active_piece(index)

            @from_index = index
            @selected_piece = true
          end

          # TODO ひとまず動く物を作った。リファクタリングする
          [sente_player, gote_player].each do |player|
            next unless player.win?

            TerminalOperator.print_winner(player)
            exit
          end
        end
      end
    end

    private

    attr_reader :board, :sente_player, :gote_player, :selected_piece, :from_index, :teban_player, :previous_board

    def change_teban!
      @teban_player = teban_player == sente_player ? gote_player : sente_player
    end

    def active_piece(index)
      # TODO case で指定しないといけないのイケてないのでリファクタしたい
      case index[:location]
      when :board
        TerminalOperator.active_piece(location: board, piece_index: index)
      when :sente_komadai
        TerminalOperator.active_piece(location: sente_player.komadai, piece_index: index)
      when :gote_komadai
        TerminalOperator.active_piece(location: gote_player.komadai, piece_index: index)
      end
    end
  end
end
