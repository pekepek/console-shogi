module ConsoleShogi
  class Terminal
    class Cursor
      TerminalPosition = Struct.new(:x, :y)

      VERTICAL_DISTANCE = 1
      HORIZONTAL_DISTANCE = 2
      CURSOR_DIRECTIONS = %w(A B C D)

      attr_reader :terminal_position, :grid_position

      def initialize(terminal_index_x: 1, terminal_index_y: 1)
        @terminal_position = TerminalPosition.new(x: 1, y: 1)
        @grid_position = GridPosition.new(**calculate_grid_position)
      end

      def move!(direction)
        return unless CURSOR_DIRECTIONS.include?(direction)

        position =
          case direction
          when 'A'
            {x: terminal_position.x, y: [terminal_position.y - VERTICAL_DISTANCE, 1].max}
          when 'B'
            {x: terminal_position.x, y: terminal_position.y + VERTICAL_DISTANCE}
          when 'C'
            {x: terminal_position.x + HORIZONTAL_DISTANCE, y: terminal_position.y}
          when 'D'
            {x: [terminal_position.x - HORIZONTAL_DISTANCE, 1].max, y: terminal_position.y}
          end

        @terminal_position = TerminalPosition.new(**position)
        @grid_position = GridPosition.new(**calculate_grid_position)
      end

      def same_position?(other_cursor)
        grid_position == other_cursor.grid_position
      end

      private

      def update_terminal_position!
        positions = fetch_cursor_position_in_stdin

        @terminal_position = TerminalPosition.new(x: positions[2].to_i, y: positions[1].to_i)
        @grid_position = GridPosition.new(**calculate_grid_position)
      end

      def calculate_grid_position
        area = DisplayArea.fetch_area(x: terminal_position.x, y: terminal_position.y)

        # TODO history や infomation の扱いを整理する
        if area.outside?
          {row: nil, column: nil, location: area}
        else
          {
            row: (terminal_position.x - area.start_position.x) / HORIZONTAL_DISTANCE,
            column: terminal_position.y - area.start_position.y,
            location: area
          }
        end
      end

      def fetch_cursor_position_in_stdin
        stdout = ''

        $stdin.raw do |stdin|
          $stdout << "\e[6n"
          $stdout.flush

          # NOTE \e[n;mR という形式で現在位置が返ってくる
          while (c = stdin.getc) != 'R'
            stdout += c
          end
        end

        stdout.match /(\d+);(\d+)/
      end
    end
  end
end
