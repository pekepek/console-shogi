# frozen_string_literal: true

require 'matrix'

module ConsoleShogi
  module Boards
    NEW_BOARD =
      [
        [
          Kyosha.new(player: Piece::GOTE),
          Keima.new(player: Piece::GOTE),
          Gin.new(player: Piece::GOTE),
          Kin.new(player: Piece::GOTE),
          Ohsho.new(player: Piece::GOTE),
          Kin.new(player: Piece::GOTE),
          Gin.new(player: Piece::GOTE),
          Keima.new(player: Piece::GOTE),
          Kyosha.new(player: Piece::GOTE)
        ],
        [
          None.new,
          Kaku.new(player: Piece::GOTE),
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          Hisha.new(player: Piece::GOTE),
          None.new
        ],
        [
          Hu.new(player: Piece::GOTE),
          Hu.new(player: Piece::GOTE),
          Hu.new(player: Piece::GOTE),
          Hu.new(player: Piece::GOTE),
          Hu.new(player: Piece::GOTE),
          Hu.new(player: Piece::GOTE),
          Hu.new(player: Piece::GOTE),
          Hu.new(player: Piece::GOTE),
          Hu.new(player: Piece::GOTE)
        ],
        [
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new
        ],
        [
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new
        ],
        [
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          None.new
        ],
        [
          Hu.new(player: Piece::SENTE),
          Hu.new(player: Piece::SENTE),
          Hu.new(player: Piece::SENTE),
          Hu.new(player: Piece::SENTE),
          Hu.new(player: Piece::SENTE),
          Hu.new(player: Piece::SENTE),
          Hu.new(player: Piece::SENTE),
          Hu.new(player: Piece::SENTE),
          Hu.new(player: Piece::SENTE)
        ],
        [
          None.new,
          Kaku.new(player: Piece::SENTE),
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          Hisha.new(player: Piece::SENTE),
          None.new
        ],
        [
          Kyosha.new(player: Piece::SENTE),
          Keima.new(player: Piece::SENTE),
          Gin.new(player: Piece::SENTE),
          Kin.new(player: Piece::SENTE),
          Ohsho.new(player: Piece::SENTE),
          Kin.new(player: Piece::SENTE),
          Gin.new(player: Piece::SENTE),
          Keima.new(player: Piece::SENTE),
          Kyosha.new(player: Piece::SENTE)
        ]
      ]
  end
end
