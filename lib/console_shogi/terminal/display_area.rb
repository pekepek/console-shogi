module ConsoleShogi
  module Terminal
    class DisplayArea
      OTHERS = :others
      BOARD = :board
      SENTE_KOMADAI = :sente_komadai
      GOTE_KOMADAI = :gote_komadai

      Position = Struct.new(:x, :y)

      class << self
        def fetch_area(x:, y:)
          if Board.in?(x: x, y: y)
            Board
          elsif Komadai::Gote.in?(x: x, y: y)
            Komadai::Gote
          elsif Komadai::Sente.in?(x: x, y: y)
            Komadai::Sente
          else
            Others
          end
        end

        def start_position
          self::START_POSITION
        end

        def end_position
          self::END_POSITION
        end

        def location
          self::LOCATION
        end

        def others?
          false
        end

        def in?(x:, y:)
          Range.new(start_position.x, end_position.x).include?(x) &&
            Range.new(start_position.y, end_position.y).include?(y)
        end
      end

      class Board < DisplayArea
        START_POSITION = Position.new(x: 1, y: 1)
        END_POSITION = Position.new(x: 18, y: 9)
        LOCATION = :board
      end

      module Komadai
        class Gote < DisplayArea
          START_POSITION = Position.new(x: 21, y: 1)
          END_POSITION = Position.new(x: 38, y: 3)
          LOCATION = :gote_komadai
        end

        class Sente < DisplayArea
          START_POSITION = Position.new(x: 21, y: 7)
          END_POSITION = Position.new(x: 38, y: 9)
          LOCATION = :sente_komadai
        end
      end

      class Others < DisplayArea
        START_POSITION = Position.new(x: nil, y: nil)
        END_POSITION = Position.new(x: nil, y: nil)
        LOCATION = :others

        def self.others?
          true
        end
      end
    end
  end
end
