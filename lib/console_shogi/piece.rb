# frozen_string_literal: true

module ConsoleShogi
  class Piece
    def initialize(player_number: nil)
      @player_number = player_number
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

    def player_one?
      player_number == 1
    end

    def player_two?
      player_number == 2
    end

    private

    attr_reader :player_number
  end

  class None < Piece
    NUMBER = 0
    DISPLAY_NAME = '　'
  end

  class Hu < Piece
    NUMBER = 1
    DISPLAY_NAME = '歩'
  end

  class Kyosha < Piece
    NUMBER = 2
    DISPLAY_NAME = '香'
  end

  class Keima < Piece
    NUMBER = 3
    DISPLAY_NAME = '桂'
  end

  class Gin < Piece
    NUMBER = 4
    DISPLAY_NAME = '銀'
  end

  class Kin < Piece
    NUMBER = 5
    DISPLAY_NAME = '金'
  end

  class Kaku < Piece
    NUMBER = 6
    DISPLAY_NAME = '角'
  end

  class Hisha < Piece
    NUMBER = 7
    DISPLAY_NAME = '飛'
  end

  class Ohsho < Piece
    NUMBER = 8
    DISPLAY_NAME = '王'
  end
end
