module ConsoleShogi
  module Terminal
    class Cursor
      module Location
        NONE = :none
        BOARD = :board
        SENTE_KOMADAI = :sente_komadai
        GOTE_KOMADAI = :gote_komadai
      end

      TerminalPosition = Struct.new(:x, :y)
      SquaresPosition = Struct.new(:x, :y, :location)

      VERTICAL_DISTANCE = 1
      HORIZONTAL_DISTANCE = 2
      CURSOR_DIRECTIONS = %w(A B C D)

      attr_reader :terminal_position, :squares_position

      def initialize(terminal_index_x: 1, terminal_index_y: 1)
        @terminal_position = TerminalPosition.new(x: 1, y: 1)
        @squares_position = SquaresPosition.new(**calculate_squares_position)
      end

      def move(direction)
        return unless CURSOR_DIRECTIONS.include?(direction)

        distance =
          case direction
          when 'A', 'B'
            VERTICAL_DISTANCE
          when 'C', 'D'
            HORIZONTAL_DISTANCE
          end

        print "\e[#{distance}#{direction}"

        update_terminal_position!
      end

      private

      def update_terminal_position!
        positions = fetch_cursor_position_in_stdin

        @terminal_position = TerminalPosition.new(x: positions[2].to_i, y: positions[1].to_i)
        @squares_position = SquaresPosition.new(**calculate_squares_position)
      end

      def calculate_squares_position
        case terminal_position.to_h
        in x: 1..18, y: 1..9
          {x: (terminal_position.x - 1) / HORIZONTAL_DISTANCE, y: terminal_position.y - 1, location: Location::BOARD}
        in x: 21..38, y: 1..3
          {x: (terminal_position.x - 21) / HORIZONTAL_DISTANCE, y: terminal_position.y - 1, location: Location::GOTE_KOMADAI}
        in x: 21..38, y: 7..9
          {x: (terminal_position.x - 21) / HORIZONTAL_DISTANCE, y: terminal_position.y - 7, location: Location::SENTE_KOMADAI}
        else
          {x: (terminal_position.x - 1) / HORIZONTAL_DISTANCE, y: terminal_position.y - 1, location: Location::NONE}
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
