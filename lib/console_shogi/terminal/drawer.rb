# frozen_string_literal: true

require 'base64'
require 'tty-prompt'

module ConsoleShogi
  module Terminal
    class Drawer
      class << self
        TEBAN = {
          sente: '先手',
          gote: '後手'
        }

        module EscapeSequence
          RESET = "\e[0m"
          SCREEN_CLEAR = "\e[2J"
          SCREEN_CLEAR_AFTER_CURSOR = "\e[0J"
          SCREEN_CLEAR_NOW_LINE = "\e[2K"
          MOVE_START_POINT = "\e[1;1H"
          MOVE_HISTORY_AREA = "\e[#{DisplayArea::History.start_position.y};#{DisplayArea::History.start_position.x}H"
          MOVE_INFOMATION_AREA = "\e[#{DisplayArea::Infomation.start_position.y};#{DisplayArea::Infomation.start_position.x}H"
          CURRENT_POSITION = "\e[6n"
          MOVE_RIGHT_2 = "\e[2C"
        end

        def cursor
          @cursor ||= Cursor.new
        end

        def image_height
          @image_height ||= calculate_fit_image_height
        end

        def clear_scrren
          print EscapeSequence::SCREEN_CLEAR

          print EscapeSequence::MOVE_START_POINT
        end

        def print_board(board:, sente_komadai:, gote_komadai:)
          print EscapeSequence::MOVE_START_POINT

          board.matrix.row_vectors.each_with_index do |vector, i|
            vector.each_with_index do |piece, j|
              print_image(image: piece.image, height: image_height)
            end

            print "#{EscapeSequence::RESET}\n"
          end

          # NOTE 駒台を表示
          print_komadai(komadai: sente_komadai, start_position: DisplayArea::Komadai::Sente.start_position)
          print_komadai(komadai: gote_komadai, start_position: DisplayArea::Komadai::Gote.start_position)

          back_to_cursor
        end

        # TODO 駒台の表示方法も考える
        def print_diff_board(previous_board:, board:, sente_komadai:, gote_komadai:)
          print EscapeSequence::MOVE_START_POINT

          board.matrix.row_vectors.each_with_index do |vector, i|
            vector.each_with_index do |piece, j|
              if previous_board.matrix[i, j].nil? || previous_board.matrix[i, j].same?(piece)
                print EscapeSequence::MOVE_RIGHT_2
              else
                print_image(image: piece.image, height: image_height)
              end
            end

            print "#{EscapeSequence::RESET}\n"
          end

          # NOTE 駒台を表示
          print_komadai(komadai: sente_komadai, start_position: DisplayArea::Komadai::Sente.start_position)
          print_komadai(komadai: gote_komadai, start_position: DisplayArea::Komadai::Gote.start_position)

          back_to_cursor
        end

        def print_start_history
          print EscapeSequence::MOVE_INFOMATION_AREA
          print EscapeSequence::SCREEN_CLEAR_AFTER_CURSOR

          print '履歴モード'

          back_to_cursor
        end

        def focus_piece(board:, cursor:)
          piece = board.fetch_piece(x: cursor.grid_position.x, y: cursor.grid_position.y)

          return if piece.nil?

          print_image(image: piece.focused_image, height: image_height)

          back_to_cursor
        end

        def deactive_piece(board:, previous_cursor:)
          print "\e[#{previous_cursor.terminal_position.y};#{previous_cursor.terminal_position.x}H"

          piece = board.fetch_piece(x: previous_cursor.grid_position.x, y: previous_cursor.grid_position.y)

          print_image(image: piece.image, height: image_height) unless piece.nil?

          back_to_cursor
        end

        def active_piece(board:, cursor:)
          piece = board.fetch_piece(x: cursor.grid_position.x, y: cursor.grid_position.y)

          return if piece.nil?

          print_image(image: piece.active_image, height: image_height)

          back_to_cursor
        end

        def select_promotion
          print EscapeSequence::MOVE_INFOMATION_AREA

          prompt = TTY::Prompt.new

          prompt.select('成りますか？', show_help: :never) {|menu|
            menu.choice '成る', true
            menu.choice '成らない', false
          }
        end

        def print_winner(player)
          print "\e[4;7H"

          print_image(image: player.win_image, height: image_height * 3)

          print EscapeSequence::MOVE_INFOMATION_AREA
        end

        # TODO 見た目は後で直す
        def print_teban(teban)
          print EscapeSequence::MOVE_INFOMATION_AREA
          print EscapeSequence::SCREEN_CLEAR_AFTER_CURSOR

          print "手番 : #{TEBAN[teban.to_sym]}"

          back_to_cursor
        end

        # TODO データの指定の仕方は後で整理する
        def print_history_button
          print EscapeSequence::MOVE_HISTORY_AREA
          print EscapeSequence::SCREEN_CLEAR_NOW_LINE

          print_image(image: File.read("images/history_button/left.png"), height: image_height)
          print_image(image: File.read("images/history_button/right.png"), height: image_height)
          print_image(image: File.read("images/history_button/play.png"), height: image_height)

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
          print EscapeSequence::MOVE_START_POINT

          fixed_height
        end

        # TODO view 用の Player 作って整理する
        def print_komadai(komadai:, start_position:)
          komadai.pieces.row_vectors.each_with_index do |row_pieces, i|
            print "\e[#{start_position.y + i};#{start_position.x}H"

            row_pieces.each do |p|
              print_image(image: p.image, height: image_height)
            end
          end

          print EscapeSequence::RESET
        end

        # TODO Cursor にも持っているので整理する
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

        def back_to_cursor
          print "\e[#{cursor.terminal_position.y};#{cursor.terminal_position.x}H"
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
end
