# frozen_string_literal: true

require 'matrix'

module ConsoleShogi
  class Board
    def initialize(pieces:, sente_player:, gote_player:)
      @pieces = Matrix.rows(pieces)
      @sente_player = sente_player
      @gote_player = gote_player
    end

    def matrix
      @pieces
    end

    def fetch_piece(x:, y:)
      pieces[y, x]
    end

    def move_piece!(from:, to:)
      from_piece = @pieces[from[:y], from[:x]]
      @pieces[from[:y], from[:x]] = NonePiece.new

      to_piece = @pieces[to[:y], to[:x]]
      @pieces[to[:y], to[:x]] = from_piece

      return if to_piece.none?

      # NOTE 駒を取る、リファクタする
      player = to_piece.player.sente? ? gote_player : sente_player

      to_piece.change_player!(player)
      player.capture_piece(to_piece)
    end

    private

    attr_reader :pieces, :sente_player, :gote_player
  end
end
