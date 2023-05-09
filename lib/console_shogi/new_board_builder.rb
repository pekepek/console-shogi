# frozen_string_literal: true

module ConsoleShogi
  class NewBoardBuilder
    class << self
      def build(sente_player: , gote_player:)
        Board.new(
          pieces: [
            [
              Kyosha.new(player: gote_player),
              Keima.new(player: gote_player),
              Gin.new(player: gote_player),
              Kin.new(player: gote_player),
              Ohsho.new(player: gote_player),
              Kin.new(player: gote_player),
              Gin.new(player: gote_player),
              Keima.new(player: gote_player),
              Kyosha.new(player: gote_player)
            ],
            [
              NonePiece.new,
              Kaku.new(player: gote_player),
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              Hisha.new(player: gote_player),
              NonePiece.new
            ],
            [
              Hu.new(player: gote_player),
              Hu.new(player: gote_player),
              Hu.new(player: gote_player),
              Hu.new(player: gote_player),
              Hu.new(player: gote_player),
              Hu.new(player: gote_player),
              Hu.new(player: gote_player),
              Hu.new(player: gote_player),
              Hu.new(player: gote_player)
            ],
            [
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new
            ],
            [
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new
            ],
            [
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new
            ],
            [
              Hu.new(player: sente_player),
              Hu.new(player: sente_player),
              Hu.new(player: sente_player),
              Hu.new(player: sente_player),
              Hu.new(player: sente_player),
              Hu.new(player: sente_player),
              Hu.new(player: sente_player),
              Hu.new(player: sente_player),
              Hu.new(player: sente_player)
            ],
            [
              NonePiece.new,
              Kaku.new(player: sente_player),
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              Hisha.new(player: sente_player),
              NonePiece.new
            ],
            [
              Kyosha.new(player: sente_player),
              Keima.new(player: sente_player),
              Gin.new(player: sente_player),
              Kin.new(player: sente_player),
              Ohsho.new(player: sente_player),
              Kin.new(player: sente_player),
              Gin.new(player: sente_player),
              Keima.new(player: sente_player),
              Kyosha.new(player: sente_player)
            ]
          ]
        )
      end
    end
  end
end
