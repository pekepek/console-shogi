module ConsoleShogi
  module Terminal
    module DisplayArea
      module Board
        START_INDEX = {x: 1, y: 1}
        END_INDEX = {x: 18, y: 9}
        RANGE = {x: Range.new(START_INDEX[:x], END_INDEX[:x]), y: Range.new(START_INDEX[:y], END_INDEX[:y])}
      end

      module Komadai
        module Gote
          START_INDEX = {x: 21, y: 1}
          END_INDEX = {x: 38, y: 3}
          RANGE = {x: Range.new(START_INDEX[:x], END_INDEX[:x]), y: Range.new(START_INDEX[:y], END_INDEX[:y])}
        end

        module Sente
          START_INDEX = {x: 21, y: 7}
          END_INDEX = {x: 38, y: 9}
          RANGE = {x: Range.new(START_INDEX[:x], END_INDEX[:x]), y: Range.new(START_INDEX[:y], END_INDEX[:y])}
        end
      end

      module OutSide
        START_INDEX = {x: 10, y: 1}
        RANGE = {x: Range.new(START_INDEX[:x], nil), y: Range.new(START_INDEX[:y], nil)}
      end
    end
  end
end
