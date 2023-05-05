# frozen_string_literal: true

require 'io/console'

module ConsoleShogi
  class Game
    def initialize
      @board = Board.new
    end

    def start
      Viewer.pretty_print(board: board)

      while key = STDIN.getch
        # NOTE Ctrl-C を押したら終了
        if key == "\C-c"
          exit
        # NOTE 矢印キーを押したらカーソルを移動
        elsif key == "\e" && STDIN.getch == "["
          key = STDIN.getch

          move_cursor(key) if %w(A B C D).include?(key)
        # NOTE Enter を押したら駒を移動
        elsif type_enter?(key)
          from_position = get_cursor_position

          while key = STDIN.getch
            if key == "\e" && STDIN.getch == "["
              key = STDIN.getch

              move_cursor(key) if %w(A B C D).include?(key)
            elsif type_enter?(key)
              to_position = get_cursor_position
              to_position[:x] = (to_position[:x] - 1) / 2 + 1
              from_position[:x] = (from_position[:x] - 1) / 2 + 1

             board.change_pirce(from: [from_position[:y] - 1, from_position[:x] - 1], to: [to_position[:y] - 1, to_position[:x] - 1])

              break
            end
          end
        end

        position = get_cursor_position

        Viewer.pretty_print(board: board)

        # NOTE back a cursor
        print "\e[#{position[:y]};#{position[:x]}H"
      end
    end

    private

    attr_reader :board

    def move_cursor(key)
      direction =
        case key
        when 'A', 'B'
          key
        when 'C', 'D'
          "2#{key}"
        end

      print "\e[#{direction}" if direction
    end

    def get_cursor_position
      stdout = ''

      $stdin.raw do |stdin|
        $stdout << "\e[6n"
        $stdout.flush

        while (c = stdin.getc) != 'R'
          stdout += c
        end
      end

      positions = stdout.match /(\d+);(\d+)/

      {x: positions[2].to_i, y: positions[1].to_i}
    end

    def type_enter?(key)
      key == "\r"
    end
  end
end
