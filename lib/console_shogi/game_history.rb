# frozen_string_literal: true

require 'io/console'

module ConsoleShogi
  class GameHistory
    def initialize(game_histories:)
      @game_histories = game_histories
      # TODO game_count という名前は分かりづらいので変える
      @game_count = game_histories.count

      Terminal::Operator.print_start_history
    end

    def start
      while key = STDIN.getch
        cursor = Terminal::Operator.cursor

        # NOTE Ctrl-C を押したら終了
        if key == "\C-c"
          exit
        # NOTE 矢印キーを押したらカーソルを移動
        elsif key == "\e" && STDIN.getch == "["
          key = STDIN.getch

          cursor.move(key)
        elsif key == "\r"
          location = cursor.grid_position.location

          next unless location.history?

          if location.resume?
            Terminal::Operator.clear_scrren

            Terminal::Operator.print_board(board: game_histories.last[:board], sente_komadai: game_histories.last[:sente_komadai], gote_komadai: game_histories.last[:gote_komadai])
            Terminal::Operator.print_history_button

            return
          elsif location.back?
            next if game_count == 1

            @game_count -= 1

            Terminal::Operator.print_board(board: game_histories[game_count - 1][:board], sente_komadai: game_histories[game_count - 1][:sente_komadai], gote_komadai: game_histories[game_count - 1][:gote_komadai])
          elsif location.forward?
            next if game_count == game_histories.count

            @game_count += 1

            Terminal::Operator.print_board(board: game_histories[game_count - 1][:board], sente_komadai: game_histories[game_count - 1][:sente_komadai], gote_komadai: game_histories[game_count - 1][:gote_komadai])
          end
        end
      end
    end

    private

    attr_reader :game_histories, :game_count
  end
end
