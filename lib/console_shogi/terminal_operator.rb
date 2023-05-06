# frozen_string_literal: true

module ConsoleShogi
  class TerminalOperator
    class << self
      CursorPosition = Struct.new(:x, :y)
      HORIZONTAL_DISTANCE = 2

      def cursor_position
        @cursor_position ||= CursorPosition.new(x: 1, y: 1)
      end

      def print_board(board:)
        # 画面をクリア
        print "\e[2J"

        # カーソルを1行1列に移動
        print "\e[1;1H"

        board.matrix.row_vectors.each_with_index do |vector, i|
          vector.each_with_index do |piece, j|
            print (i + j) % 2 == 0 ? "\e[42m" : "\e[43m"

            if piece.player.gote?
              print "\e[30m"
            elsif piece.player.sente?
              print "\e[37m"
            end

            print piece.display_name
          end

          print "\e[0m\n"
        end

        # NOTE back a cursor
        print "\e[#{cursor_position.y};#{cursor_position.x}H"
      end

      def move_cursor(key)
        return unless %w(A B C D).include?(key)

        direction =
          case key
          when 'A', 'B'
            key
          when 'C', 'D'
            "#{HORIZONTAL_DISTANCE}#{key}"
          end

        print "\e[#{direction}"

        reload_cursor_position_in_stdin!
      end

      def squares_index
        {x: (cursor_position.x - 1) / HORIZONTAL_DISTANCE, y: cursor_position.y - 1}
      end

      private

      def reload_cursor_position_in_stdin!
        stdout = ''

        $stdin.raw do |stdin|
          $stdout << "\e[6n"
          $stdout.flush

          while (c = stdin.getc) != 'R'
            stdout += c
          end
        end

        positions = stdout.match /(\d+);(\d+)/

        @cursor_position = CursorPosition.new(x: positions[2].to_i, y: positions[1].to_i)
      end
    end
  end
end
