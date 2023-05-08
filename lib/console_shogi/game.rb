# frozen_string_literal: true

require 'io/console'

module ConsoleShogi
  class Game
    def initialize
      @sente_player = Player.new(teban: Player::Teban::SENTE)
      @gote_player = Player.new(teban: Player::Teban::GOTE)
      @board = NewBoardBuilder.build(sente_player: @sente_player, gote_player: @gote_player)
    end

    def start
      TerminalOperator.print_board(board: board, sente_player: sente_player, gote_player: gote_player)

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
          PieceMover.new(board: board, from: TerminalOperator.squares_index).move
        end

        TerminalOperator.print_board(board: board, sente_player: sente_player, gote_player: gote_player)
      end
    end

    private

    attr_reader :board, :sente_player, :gote_player
  end
end
