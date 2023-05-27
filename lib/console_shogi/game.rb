# frozen_string_literal: true

require 'io/console'

module ConsoleShogi
  class Game
    def initialize
      @sente_player = Player.new(teban: Teban::SENTE)
      @gote_player = Player.new(teban: Teban::GOTE)
      @board = NewBoardBuilder.build(sente_player: @sente_player, gote_player: @gote_player)

      @from_index = nil
      @selected_piece = false
    end

    def start
      TerminalOperator.print_board(board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)

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
            case from_index[:location]
            when :board
              PieceMover.new(board: board, from: from_index, to: index).move!
            when :sente_komadai
              PieceMoverOnKomadai.new(board: board, komadai: sente_player.komadai, from: from_index, to: index).drop!
            when :gote_komadai
              PieceMoverOnKomadai.new(board: board, komadai: gote_player.komadai, from: from_index, to: index).drop!
            end

            # TODO 描写に時間がかかるので、差分のみ表示できる様にする
            TerminalOperator.print_board(board: board, sente_komadai: sente_player.komadai, gote_komadai: gote_player.komadai)

            @from_index = nil
            @selected_piece = false
          else
            next if index[:location] == :none

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

    attr_reader :board, :sente_player, :gote_player, :selected_piece, :from_index
  end
end
