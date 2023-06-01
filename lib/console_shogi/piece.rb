# frozen_string_literal: true

module ConsoleShogi
  class Piece
    attr_accessor :teban

    def initialize(teban: nil)
      @teban = teban
    end

    def move
      raise NotImplementedError
    end

    def promote
      return self unless can_promote?

      promoted
    end

    def promoted?
      false
    end

    def number
      self::class::NUMBER
    end

    def image
      File.read("images/nomal/#{teban}/#{self::class.name.split('::').last.downcase}.png")
    end

    def active_image
      File.read("images/active/#{teban}/#{self::class.name.split('::').last.downcase}.png")
    end

    def focused_image
      File.read("images/focused/#{teban}/#{self::class.name.split('::').last.downcase}.png")
    end

    def none?
      self::class == NonePiece
    end

    def fu?
      self::class == Fu
    end

    def moves
      ms = base_moves

      if teban == Teban::SENTE
        ms
      else
        ms.map {|m| m.transform_values {|v| v * -1 } }
      end
    end

    def change_player!(player)
      @player = player
    end

    def can_move_long_distance?
      [Kaku, Hisha, Kyosha, PromotedPiece::Uma, PromotedPiece::Ryu].include?(self::class)
    end
  end

  class NonePiece < Piece
    NUMBER = 0

    def moves
      []
    end

    def image
      File.read("images/nomal/nonepiece.png")
    end

    def active_image
      File.read("images/active/nonepiece.png")
    end

    def focused_image
      File.read("images/focused/nonepiece.png")
    end

    def can_promote?
      false
    end
  end

  class Fu < Piece
    NUMBER = 1

    def base_moves
      [
        {x: 0, y: -1}
      ]
    end

    def can_promote?
      true
    end

    def promoted
      PromotedPiece::Tokin.new(original: self)
    end
  end

  class Kyosha < Piece
    NUMBER = 2

    def base_moves
      (1..8).map {|n|
        {x: 0, y: -1 * n}
      }
    end

    def can_promote?
      true
    end

    def promoted
      PromotedPiece::Narikyo.new(original: self)
    end
  end

  class Keima < Piece
    NUMBER = 3

    def base_moves
      [
        {x: 1, y: -2},
        {x: -1, y: -2},
      ]
    end

    def can_promote?
      true
    end

    def promoted
      PromotedPiece::Narikei.new(original: self)
    end
  end

  class Gin < Piece
    NUMBER = 4

    def base_moves
      [
        {x: -1, y: -1},
        {x: 0, y: -1},
        {x: 1, y: -1},
        {x: 1, y: 1},
        {x: -1, y: 1}
      ]
    end

    def can_promote?
      true
    end

    def promoted
      PromotedPiece::Narigin.new(original: self)
    end
  end

  class Kin < Piece
    NUMBER = 5

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

    def can_promote?
      false
    end
  end

  class Kaku < Piece
    NUMBER = 6

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

     def can_promote?
      true
    end

    def promoted
      PromotedPiece::Uma.new(original: self)
    end
  end

  class Hisha < Piece
    NUMBER = 7

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

    def can_promote?
      true
    end

    def promoted
      PromotedPiece::Ryu.new(original: self)
    end
  end

  class Ohsho < Piece
    NUMBER = 8

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

    def can_promote?
      false
    end
  end

  class PromotedPiece < Piece
    attr_reader :original

    def initialize(original: nil)
      @original = original
    end

    def teban
      original.teban
    end

    def teban=(val)
      original.teban = val
    end

    def can_promote?
      false
    end

    def promoted?
      true
    end

    class NariKin < PromotedPiece
      NUMBER = 9

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

    class Narigin < NariKin; end
    class Narikei < NariKin; end
    class Narikyo < NariKin; end
    class Tokin < NariKin; end

    class Uma < PromotedPiece
      NUMBER = 10

      def base_moves
        (1..8).flat_map {|n|
          [
            {x: -1 * n, y: -1 * n},
            {x: 1 * n, y: -1 * n},
            {x: -1 * n, y: 1 * n},
            {x: 1 * n, y: 1 * n}
          ]
        } + [
          {x: 0, y: -1},
          {x: 1, y: 0},
          {x: -1, y: 0},
          {x: 0, y: 1}
        ]
      end
    end

    class Ryu < PromotedPiece
      NUMBER = 11

      def base_moves
        (1..8).flat_map {|n|
          [
            {x: 0, y: -1 * n},
            {x: 0, y: 1 * n},
            {x: -1 * n, y: 0},
            {x: 1 * n, y: 0}
          ]
        } + [
          {x: -1, y: -1},
          {x: 1, y: -1},
          {x: -1, y: 1},
          {x: 1, y: 1}
        ]
      end
    end
  end
end
