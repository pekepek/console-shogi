# frozen_string_literal: true

module ConsoleShogi
  class Piece
    attr_reader :player

    def initialize(player: nil)
      @player = player
    end

    def move
      raise NotImplementedError
    end

    def promote
      raise NotImplementedError
    end

    def number
      self::class::NUMBER
    end

    def display_name
      self::class::DISPLAY_NAME
    end

    def none?
      self::class == NonePiece
    end

    def kaku?
      self::class == Kaku
    end

    def hisha?
      self::class == Hisha
    end

    def kyosha?
      self::class == Kyosha
    end

    def moves
      ms = base_moves

      if player.sente?
        ms
      else
        ms.map {|m| m.transform_values {|v| v * -1 } }
      end
    end

    def change_player!(player)
      @player = player
    end
  end

  class NonePiece < Piece
    NUMBER = 0
    DISPLAY_NAME = '　'

    def none?
      true
    end

    def moves
      []
    end

    def player
      NonPlayer.new
    end
  end

  class Hu < Piece
    NUMBER = 1
    DISPLAY_NAME = '歩'

    def base_moves
      [
        {x: 0, y: -1}
      ]
    end
  end

  class Kyosha < Piece
    NUMBER = 2
    DISPLAY_NAME = '香'

    def base_moves
      (1..8).map {|n|
        {x: 0, y: -1 * n}
      }
    end
  end

  class Keima < Piece
    NUMBER = 3
    DISPLAY_NAME = '桂'

    def base_moves
      [
        {x: 1, y: -2},
        {x: -1, y: -2},
      ]
    end
  end

  class Gin < Piece
    NUMBER = 4
    DISPLAY_NAME = '銀'

    def base_moves
      [
        {x: -1, y: -1},
        {x: 0, y: -1},
        {x: 1, y: -1},
        {x: 1, y: 1},
        {x: -1, y: 1}
      ]
    end
  end

  class Kin < Piece
    NUMBER = 5
    DISPLAY_NAME = '金'

    def base_moves
      [
        {x: -1, y: -1},
        {x: 0, y: -1},
        {x: 1, y: -1},
        {x: 1, y: 0},
        {x: -1, y: 0},
        {x: 0, y: 1}
      ]
    end
  end

  class Kaku < Piece
    NUMBER = 6
    DISPLAY_NAME = '角'

    def base_moves
      (1..8).flat_map {|n|
        [
          {x: -1 * n, y: -1 * n},
          {x: 1 * n, y: -1 * n},
          {x: -1 * n, y: 1 * n},
          {x: 1 * n, y: 1 * n}
        ]
      }
    end
  end

  class Hisha < Piece
    NUMBER = 7
    DISPLAY_NAME = '飛'

    def base_moves
      (1..8).flat_map {|n|
        [
          {x: 0, y: -1 * n},
          {x: 0, y: 1 * n},
          {x: -1 * n, y: 0},
          {x: 1 * n, y: 0}
        ]
      }
    end
  end

  class Ohsho < Piece
    NUMBER = 8
    DISPLAY_NAME = '王'

    def base_moves
      [
        {x: -1, y: -1},
        {x: 0, y: -1},
        {x: 1, y: -1},
        {x: 1, y: 0},
        {x: -1, y: 0},
        {x: -1, y: 1},
        {x: 0, y: 1},
        {x: 1, y: 1}
      ]
    end
  end
end
