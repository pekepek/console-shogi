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
          [Board, Komadai::Gote, Komadai::Sente, History::Back, History::Forward, History::Resume, Infomation].each do |klass|
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

        def name
          self::NAME
        end

        def board?
          Board == self
        end

        def komadai?
          [Komadai::Gote, Komadai::Sente].include?(self)
        end

        def history?
          [History::Back, History::Forward, History::Resume].include?(self)
        end

        def outside?
          [History::Back, History::Forward, History::Resume, Infomation, Others].include?(self)
        end

        def in?(x:, y:)
          Range.new(start_position.x, end_position.x).include?(x) &&
            Range.new(start_position.y, end_position.y).include?(y)
        end
      end

      class Board < DisplayArea
        START_POSITION = Position.new(x: 1, y: 1)
        END_POSITION = Position.new(x: 18, y: 9)
        NAME = :board
      end

      module Komadai
        class Gote < DisplayArea
          START_POSITION = Position.new(x: 21, y: 1)
          END_POSITION = Position.new(x: 38, y: 3)
          NAME = :gote_komadai
        end

        class Sente < DisplayArea
          START_POSITION = Position.new(x: 21, y: 7)
          END_POSITION = Position.new(x: 38, y: 9)
          NAME = :sente_komadai
        end
      end

      class History < DisplayArea
        START_POSITION = Position.new(x: 1, y: 10)
        END_POSITION = Position.new(x: 6, y: 10)
        NAME = :history

        class << self
          def back?
            self == Back
          end

          def forward?
            self == Forward
          end

          def resume?
            self == Resume
          end
        end

        class Back < History
          START_POSITION = Position.new(x: 1, y: 10)
          END_POSITION = Position.new(x: 2, y: 10)
        end

        class Forward < History
          START_POSITION = Position.new(x: 3, y: 10)
          END_POSITION = Position.new(x: 4, y: 10)
        end

        class Resume < History
          START_POSITION = Position.new(x: 5, y: 10)
          END_POSITION = Position.new(x: 6, y: 10)
        end
      end

      class Infomation < DisplayArea
        START_POSITION = Position.new(x: 1, y: 11)
        END_POSITION = Position.new(x: 18, y: 15)
        NAME = :infomation
      end

      class Others < DisplayArea
        START_POSITION = Position.new(x: nil, y: nil)
        END_POSITION = Position.new(x: nil, y: nil)
        NAME = :others
      end
    end
  end
end
