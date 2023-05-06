# frozen_string_literal: true

require 'matrix'

module ConsoleShogi
  class Player
    module Teban
      SENTE = :sente
      GOTE = :gote
    end

    attr_reader :teban

    def initialize(teban: nil)
      @teban = teban
    end

    def sente?
      teban == Teban::SENTE
    end

    def gote?
      teban == Teban::GOTE
    end
  end

  class NonPlayer < Player
  end
end
