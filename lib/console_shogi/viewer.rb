# frozen_string_literal: true

module ConsoleShogi
  class Viewer
    class << self
      def pretty_print(board:)
        # 画面をクリア
        print "\e[2J"

        # カーソルを1行1列に移動
        print "\e[1;1H"

        board.matrix.row_vectors.each_with_index do |vector, i|
          vector.each_with_index do |piece, j|
            print (i + j) % 2 == 0 ? "\e[42m" : "\e[43m"

            if piece.player_one?
              print "\e[30m"
            elsif piece.player_two?
              print "\e[37m"
            end

            print piece.display_name
          end

          print "\e[0m\n"
        end

        print "\e[1;1H"
      end

      def move_cursor(&block)
        while key = STDIN.getch
          # NOTE enable to cancel a game by ctrl-c
          exit if key == "\C-c"

          if key == "\e" && STDIN.getch == "["
            key = STDIN.getch

            direction =
              case key
              when 'A', 'B'
                key
              when 'C', 'D'
                "2#{key}"
              else
                nil
              end

            print "\e[#{direction}" if direction
          end

          position = cursor_position

          block.call(key)

          # NOTE back a cursor
          print "\e[#{position[:y]};#{position[:x]}H"
        end
      end

      private

      def cursor_position
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
    end
  end
end
