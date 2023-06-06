# frozen_string_literal: true

module ConsoleShogi
  class PieceMover
    class << self
      def build(board:, player:, from_cursor:, to_cursor:)
        location = from_cursor.grid_position.location

        if location.board?
          PieceMoverFromBoard.new(
            board: board,
            player: player,
            from: from_cursor.grid_position,
            to: to_cursor.grid_position
          )
        elsif location.komadai?
          PieceMoverFromKomadai.new(
            board: board,
            player: player,
            from: from_cursor.grid_position,
            to: to_cursor.grid_position
          )
        end
      end
    end

    def move!
      @moved_piece = move_piece!
    end

    def moved_piece?
      @moved_piece
    end
  end
end
