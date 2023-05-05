# frozen_string_literal: true

require 'matrix'

module ConsoleShogi
  module Boards
    NEW_BOARD =
      [
        [
          Kyosha.new(player_number: 1),
          Keima.new(player_number: 1),
          Gin.new(player_number: 1),
          Kin.new(player_number: 1),
          Ohsho.new(player_number: 1),
          Kin.new(player_number: 1),
          Gin.new(player_number: 1),
          Keima.new(player_number: 1),
          Kyosha.new(player_number: 1)
        ],
        [
          None.new(player_number: 1),
          Kaku.new(player_number: 1),
          None.new(player_number: 1),
          None.new(player_number: 1),
          None.new(player_number: 1),
          None.new(player_number: 1),
          None.new(player_number: 1),
          Hisha.new(player_number: 1),
          None.new(player_number: 1)
        ],
        [
          Hu.new(player_number: 1),
          Hu.new(player_number: 1),
          Hu.new(player_number: 1),
          Hu.new(player_number: 1),
          Hu.new(player_number: 1),
          Hu.new(player_number: 1),
          Hu.new(player_number: 1),
          Hu.new(player_number: 1),
          Hu.new(player_number: 1)
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
          Hu.new(player_number: 2),
          Hu.new(player_number: 2),
          Hu.new(player_number: 2),
          Hu.new(player_number: 2),
          Hu.new(player_number: 2),
          Hu.new(player_number: 2),
          Hu.new(player_number: 2),
          Hu.new(player_number: 2),
          Hu.new(player_number: 2)
        ],
        [
          None.new(player_number: 2),
          Kaku.new(player_number: 2),
          None.new(player_number: 2),
          None.new(player_number: 2),
          None.new(player_number: 2),
          None.new(player_number: 2),
          None.new(player_number: 2),
          Hisha.new(player_number: 2),
          None.new(player_number: 2)
        ],
        [
          Kyosha.new(player_number: 2),
          Keima.new(player_number: 2),
          Gin.new(player_number: 2),
          Kin.new(player_number: 2),
          Ohsho.new(player_number: 2),
          Kin.new(player_number: 2),
          Gin.new(player_number: 2),
          Keima.new(player_number: 2),
          Kyosha.new(player_number: 2)
        ]
      ]
  end
end
