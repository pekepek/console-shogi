# frozen_string_literal: true

module ConsoleShogi
  class TerminalOperator
    class << self
      CursorPosition = Struct.new(:x, :y)

      HORIZONTAL_DISTANCE = 2

      module EscapeSequence
        RESET = "\e[0m"
        RESET_CURSOR = "\e[1;1H"
        BACKGROUND_COLOR_YELLOW = "\e[43m"
        BACKGROUND_COLOR_GREEN = "\e[42m"
        TEXT_COLOR_SENTE = "\e[37m"
        TEXT_COLOR_GOTE = "\e[30m"
      end

      def cursor_position
        @cursor_position ||= CursorPosition.new(x: 1, y: 1)
      end

      def print_board(board:, sente_player:, gote_player:)
        # NOTE 画面をクリア
        print "\e[2J"

        # NOTE カーソルを1行1列に移動
        print EscapeSequence::RESET_CURSOR

        board.matrix.row_vectors.each_with_index do |vector, i|
          vector.each_with_index do |piece, j|
            print (i + j) % 2 == 0 ? EscapeSequence::BACKGROUND_COLOR_GREEN : EscapeSequence::BACKGROUND_COLOR_YELLOW

            if piece.player.gote?
              print EscapeSequence::TEXT_COLOR_GOTE
            elsif piece.player.sente?
              print EscapeSequence::TEXT_COLOR_SENTE
            end

            print piece.display_name
          end

          print "#{EscapeSequence::RESET}\n"
        end

        # NOTE 駒台を表示
        print_piece_stand(sente_player)
        print_piece_stand(gote_player)

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

      PIECE_STAND_START_X = 21
      PIECE_STAND_GOTE_START_Y = 1
      PIECE_STAND_SENTE_START_Y = 7

      # TODO view 用の Player 作って整理する
      def print_piece_stand(player)
        start_y = player.sente? ? PIECE_STAND_SENTE_START_Y : PIECE_STAND_GOTE_START_Y
        text_color = player.sente? ? EscapeSequence::TEXT_COLOR_SENTE : EscapeSequence::TEXT_COLOR_GOTE

        player.komadai.pieces.row_vectors.each_with_index do |row_pieces, i|
          print "\e[#{start_y + i};#{PIECE_STAND_START_X}H"
          print EscapeSequence::BACKGROUND_COLOR_YELLOW
          print text_color

          row_pieces.each do |p|
            print p.display_name
          end

          print EscapeSequence::RESET
        end
      end

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
