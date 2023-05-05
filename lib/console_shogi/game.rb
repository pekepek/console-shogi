# frozen_string_literal: true

require 'io/console'

module ConsoleShogi
  class Game
    def initialize
      @board = Board.new
    end

    def start
      Viewer.pretty_print(board: board)

      Viewer.move_cursor do |key|
        Viewer.pretty_print(board: board)
      end
    end

    private

    attr_reader :board
  end
end
