# frozen_string_literal: true

require 'io/console'

module ConsoleShogi
  class Game
    def initialize
      @board = Board.new
      @terminal_operator = TerminalOperator.new
    end

    def start
      terminal_operator.print_board(board: board)

      while key = STDIN.getch
        # NOTE Ctrl-C を押したら終了
        if key == "\C-c"
          exit
        # NOTE 矢印キーを押したらカーソルを移動
        elsif key == "\e" && STDIN.getch == "["
          key = STDIN.getch

          terminal_operator.move_cursor(key)
        # NOTE Enter を押したら駒を移動
        elsif key == "\r"
          from_piece_index = terminal_operator.squares_index

          while key = STDIN.getch
            if key == "\e" && STDIN.getch == "["
              key = STDIN.getch

              terminal_operator.move_cursor(key)
            elsif key == "\r"
              to_piece_index = terminal_operator.squares_index

              board.change_piece(from: [from_piece_index[:y], from_piece_index[:x]], to: [to_piece_index[:y], to_piece_index[:x]])

              break
            end
          end
        end

        terminal_operator.print_board(board: board)
      end
    end

    private

    attr_reader :board, :terminal_operator
  end
end
