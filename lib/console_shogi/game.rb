# frozen_string_literal: true

require 'io/console'

module ConsoleShogi
  class Game
    def initialize
      @board = Board.new
    end

    def start
      TerminalOperator.print_board(board: board)

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

        TerminalOperator.print_board(board: board)
      end
    end

    private

    attr_reader :board
  end
end
