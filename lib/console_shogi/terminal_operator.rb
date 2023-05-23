# frozen_string_literal: true

require 'base64'
require 'tty-prompt'

module ConsoleShogi
  class TerminalOperator
    class << self
      CursorPosition = Struct.new(:x, :y)

      HORIZONTAL_DISTANCE = 2

      KOMADAI_START_X = 21
      KOMADAI_GOTE_START_Y = 1
      KOMADAI_SENTE_START_Y = 7

      module EscapeSequence
        RESET = "\e[0m"
        RESET_CURSOR = "\e[1;1H"
        BACKGROUND_COLOR_YELLOW = "\e[43m"
        BACKGROUND_COLOR_GREEN = "\e[42m"
        TEXT_COLOR_SENTE = "\e[37m"
        TEXT_COLOR_GOTE = "\e[30m"
      end

      module Location
        NONE = :none
        BOARD = :board
        SENTE_KOMADAI = :sente_komadai
        GOTE_KOMADAI = :gote_komadai
      end

      def cursor_position
        @cursor_position ||= CursorPosition.new(x: 1, y: 1)
      end

      def image_height
        @image_height ||= calculate_fit_image_height
      end

      def print_board(board:, sente_komadai:, gote_komadai:)
        # NOTE 画面をクリア
        print "\e[2J"

        # NOTE カーソルを1行1列に移動
        print EscapeSequence::RESET_CURSOR

        board.matrix.row_vectors.each_with_index do |vector, i|
          vector.each_with_index do |piece, j|
            print_image(image: piece.image, height: image_height)
          end

          print "#{EscapeSequence::RESET}\n"
        end

        # NOTE 駒台を表示
        print_komadai(sente_komadai, KOMADAI_SENTE_START_Y, EscapeSequence::TEXT_COLOR_SENTE)
        print_komadai(gote_komadai, KOMADAI_GOTE_START_Y, EscapeSequence::TEXT_COLOR_GOTE)

        # NOTE back a cursor
        back_to_cursor
      end

      def active_piece(board:, piece_index:)
        back_to_cursor

        board.fetch_piece(x: piece_index[:x], y: piece_index[:y])
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

      # TODO 駒台の大きさが変わるのをどうするか考える、メソッド名考える
      def squares_index
        case cursor_position
        in x: 1..18, y: 1..9
          {x: (cursor_position.x - 1) / HORIZONTAL_DISTANCE, y: cursor_position.y - 1, location: Location::BOARD}
        in x: 21..38, y: 1..3
          {x: (cursor_position.x - 21) / HORIZONTAL_DISTANCE, y: cursor_position.y - 1, location: Location::GOTE_KOMADAI}
        in x: 21..38, y: 7..9
          {x: (cursor_position.x - 21) / HORIZONTAL_DISTANCE, y: cursor_position.y - 7, location: Location::SENTE_KOMADAI}
        else
          {x: (cursor_position.x - 1) / HORIZONTAL_DISTANCE, y: cursor_position.y - 1, location: Location::NONE}
        end
      end

      def select_promotion
        print "\e[10;1H"

        prompt = TTY::Prompt.new

        prompt.select('成りますか？', show_help: :never) {|menu|
          menu.choice '成る', true
          menu.choice '成らない', false
        }
      end

      private

      IMAGE_HEIGHT_PIXEL = 240

      # TODO 無理やりなので、実現方法を再考する
      def calculate_fit_image_height
        start_position = fetch_cursor_position_in_stdin
        # NOTE NonePiece を選んでいることに意味はない
        print_image(image: NonePiece.new.image)
        end_position = fetch_cursor_position_in_stdin

        fixed_height = IMAGE_HEIGHT_PIXEL / (end_position[1].to_i - start_position[1].to_i)

        print "\e[2J"
        # NOTE カーソルを1行1列に移動
        print EscapeSequence::RESET_CURSOR

        fixed_height
      end

      # TODO view 用の Player 作って整理する
      def print_komadai(komadai, start_y, text_color)
        komadai.pieces.row_vectors.each_with_index do |row_pieces, i|
          print "\e[#{start_y + i};#{KOMADAI_START_X}H"
          print EscapeSequence::BACKGROUND_COLOR_YELLOW
          print text_color

          row_pieces.each do |p|
            print_image(image: p.image, height: image_height)
          end

          print EscapeSequence::RESET
        end
      end

      def fetch_cursor_position_in_stdin
        stdout = ''

        $stdin.raw do |stdin|
          $stdout << "\e[6n"
          $stdout.flush

          while (c = stdin.getc) != 'R'
            stdout += c
          end
        end

        stdout.match /(\d+);(\d+)/
      end

      def reload_cursor_position_in_stdin!
        positions = fetch_cursor_position_in_stdin

        @cursor_position = CursorPosition.new(x: positions[2].to_i, y: positions[1].to_i)
      end

      def back_to_cursor
        print "\e[#{cursor_position.y};#{cursor_position.x}H"
      end

      # TODO 画像を表示するためのメソッド、場所検討
      def print_image(image:, width: nil, height: nil)
        encoded_image = Base64.strict_encode64(image)

        print_osc
        print "1337;File=inline=1"
        print ";size=#{image.size}"
        print ";name=#{encoded_image}"
        print ";width=#{width}px" unless width.nil?
        print ";height=#{height}px" unless height.nil?
        print ":#{encoded_image}"
        print_st
      end

      def print_osc
        # NOTE \e] で始まるシーケンスは全てのターミナルで扱えるわけでは無い
        if ENV['TERM'].start_with?('screen') || ENV['TERM'].start_with?('tmux')
          print "\ePtmux;\e\e]"
        else
          print "\e]"
        end
      end

      def print_st
        if ENV['TERM'].start_with?('screen') || ENV['TERM'].start_with?('tmux')
          print "\a\e\\"
        else
          print "\a"
        end
      end
    end
  end
end
