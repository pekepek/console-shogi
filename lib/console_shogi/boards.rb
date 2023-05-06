# frozen_string_literal: true

require 'matrix'

module ConsoleShogi
  module Boards
    NEW_BOARD =
      [
        [
          Kyosha.new(player: Player.new(teban: Player::Teban::GOTE)),
          Keima.new(player: Player.new(teban: Player::Teban::GOTE)),
          Gin.new(player: Player.new(teban: Player::Teban::GOTE)),
          Kin.new(player: Player.new(teban: Player::Teban::GOTE)),
          Ohsho.new(player: Player.new(teban: Player::Teban::GOTE)),
          Kin.new(player: Player.new(teban: Player::Teban::GOTE)),
          Gin.new(player: Player.new(teban: Player::Teban::GOTE)),
          Keima.new(player: Player.new(teban: Player::Teban::GOTE)),
          Kyosha.new(player: Player.new(teban: Player::Teban::GOTE))
        ],
        [
          None.new,
          Kaku.new(player: Player.new(teban: Player::Teban::GOTE)),
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          Hisha.new(player: Player.new(teban: Player::Teban::GOTE)),
          None.new
        ],
        [
          Hu.new(player: Player.new(teban: Player::Teban::GOTE)),
          Hu.new(player: Player.new(teban: Player::Teban::GOTE)),
          Hu.new(player: Player.new(teban: Player::Teban::GOTE)),
          Hu.new(player: Player.new(teban: Player::Teban::GOTE)),
          Hu.new(player: Player.new(teban: Player::Teban::GOTE)),
          Hu.new(player: Player.new(teban: Player::Teban::GOTE)),
          Hu.new(player: Player.new(teban: Player::Teban::GOTE)),
          Hu.new(player: Player.new(teban: Player::Teban::GOTE)),
          Hu.new(player: Player.new(teban: Player::Teban::GOTE))
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
          Hu.new(player: Player.new(teban: Player::Teban::SENTE)),
          Hu.new(player: Player.new(teban: Player::Teban::SENTE)),
          Hu.new(player: Player.new(teban: Player::Teban::SENTE)),
          Hu.new(player: Player.new(teban: Player::Teban::SENTE)),
          Hu.new(player: Player.new(teban: Player::Teban::SENTE)),
          Hu.new(player: Player.new(teban: Player::Teban::SENTE)),
          Hu.new(player: Player.new(teban: Player::Teban::SENTE)),
          Hu.new(player: Player.new(teban: Player::Teban::SENTE)),
          Hu.new(player: Player.new(teban: Player::Teban::SENTE))
        ],
        [
          None.new,
          Kaku.new(player: Player.new(teban: Player::Teban::SENTE)),
          None.new,
          None.new,
          None.new,
          None.new,
          None.new,
          Hisha.new(player: Player.new(teban: Player::Teban::SENTE)),
          None.new
        ],
        [
          Kyosha.new(player: Player.new(teban: Player::Teban::SENTE)),
          Keima.new(player: Player.new(teban: Player::Teban::SENTE)),
          Gin.new(player: Player.new(teban: Player::Teban::SENTE)),
          Kin.new(player: Player.new(teban: Player::Teban::SENTE)),
          Ohsho.new(player: Player.new(teban: Player::Teban::SENTE)),
          Kin.new(player: Player.new(teban: Player::Teban::SENTE)),
          Gin.new(player: Player.new(teban: Player::Teban::SENTE)),
          Keima.new(player: Player.new(teban: Player::Teban::SENTE)),
          Kyosha.new(player: Player.new(teban: Player::Teban::SENTE))
        ]
      ]
  end
end
