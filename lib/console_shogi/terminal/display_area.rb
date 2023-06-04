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
          [Board, Komadai::Gote, Komadai::Sente, History, Infomation].each do |klass|
            return klass if klass.in?(x: x, y: y)
          end

          Others
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

        def outside?
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

      class History < DisplayArea
        START_POSITION = Position.new(x: 1, y: 10)
        END_POSITION = Position.new(x: 18, y: 10)
        LOCATION = :history

        def self.outside?
          true
        end
      end

      class Infomation < DisplayArea
        START_POSITION = Position.new(x: 1, y: 11)
        END_POSITION = Position.new(x: 18, y: 15)
        LOCATION = :infomation

        def self.outside?
          true
        end
      end

      class Others < DisplayArea
        START_POSITION = Position.new(x: nil, y: nil)
        END_POSITION = Position.new(x: nil, y: nil)
        LOCATION = :others

        def self.outside?
          true
        end
      end
    end
  end
end
