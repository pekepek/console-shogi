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
          from_position = TerminalOperator.get_cursor_position

          while key = STDIN.getch
            if key == "\e" && STDIN.getch == "["
              key = STDIN.getch

              TerminalOperator.move_cursor(key)
            elsif key == "\r"
              to_position = TerminalOperator.get_cursor_position

              to_position[:x] = (to_position[:x] - 1) / 2 + 1
              from_position[:x] = (from_position[:x] - 1) / 2 + 1

             board.change_pirce(from: [from_position[:y] - 1, from_position[:x] - 1], to: [to_position[:y] - 1, to_position[:x] - 1])

              break
            end
          end
        end

        position = TerminalOperator.get_cursor_position

        TerminalOperator.print_board(board: board, cursor_position: position)
      end
    end

    private

    attr_reader :board
  end
end
