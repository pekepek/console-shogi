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
      end
    end
  end
end
