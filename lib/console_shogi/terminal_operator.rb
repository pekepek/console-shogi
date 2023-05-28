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

      TEBAN = {
        sente: '先手',
        gote: '後手'
      }

      module EscapeSequence
        RESET = "\e[0m"
        RESET_CURSOR = "\e[1;1H"
        SCREEN_CLEAR = "\e[2J"
        SCREEN_CLEAR_AFTER_CURSOR = "\e[0J"
        OUTSIDE_BOARD = "\e[10;1H"
        CURRENT_POSITION = "\e[6n"
        MOVE_RIGHT_2 = "\e[2C"
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

      def clear_scrren
        print EscapeSequence::SCREEN_CLEAR

        print EscapeSequence::RESET_CURSOR
      end

      # TODO 駒台の表示方法も考える
      def print_diff_board(previous_board:, board:, sente_komadai:, gote_komadai:)
        print EscapeSequence::RESET_CURSOR

        board.matrix.row_vectors.each_with_index do |vector, i|
          vector.each_with_index do |piece, j|
            if previous_board.matrix[i, j] == piece
              print EscapeSequence::MOVE_RIGHT_2
            else
              print_image(image: piece.image, height: image_height)
            end
          end

          print "#{EscapeSequence::RESET}\n"
        end

        # NOTE 駒台を表示
        print_komadai(sente_komadai, KOMADAI_SENTE_START_Y)
        print_komadai(gote_komadai, KOMADAI_GOTE_START_Y)

        # NOTE back a cursor
        back_to_cursor
      end

      def active_piece(location:, piece_index:)
        back_to_cursor

        piece = location.fetch_piece(x: piece_index[:x], y: piece_index[:y])
        print_image(image: piece.active_image, height: image_height)

        back_to_cursor
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
        print EscapeSequence::OUTSIDE_BOARD

        prompt = TTY::Prompt.new

        prompt.select('成りますか？', show_help: :never) {|menu|
          menu.choice '成る', true
          menu.choice '成らない', false
        }
      end

      def print_winner(player)
        print "\e[4;7H"

        print_image(image: player.win_image, height: image_height * 3)

        print EscapeSequence::OUTSIDE_BOARD
      end

      # TODO 見た目は後で直す
      def print_teban(teban)
        print EscapeSequence::OUTSIDE_BOARD
        print EscapeSequence::SCREEN_CLEAR_AFTER_CURSOR

        print "手番 : #{TEBAN[teban.to_sym]}"

        back_to_cursor
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

        print EscapeSequence::SCREEN_CLEAR
        # NOTE カーソルを1行1列に移動
        print EscapeSequence::RESET_CURSOR

        fixed_height
      end

      # TODO view 用の Player 作って整理する
      def print_komadai(komadai, start_y)
        komadai.pieces.row_vectors.each_with_index do |row_pieces, i|
          print "\e[#{start_y + i};#{KOMADAI_START_X}H"

          row_pieces.each do |p|
            print_image(image: p.image, height: image_height)
          end
        end

        print EscapeSequence::RESET
      end

      def fetch_cursor_position_in_stdin
        stdout = ''

        $stdin.raw do |stdin|
          $stdout << EscapeSequence::CURRENT_POSITION
          $stdout.flush

          # NOTE \e[n;mR という形式で現在位置が返ってくる
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
