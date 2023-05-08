# frozen_string_literal: true

module ConsoleShogi
  class Player
    module Teban
      SENTE = :sente
      GOTE = :gote
    end

    attr_reader :teban
    attr_accessor :hand_pieces

    def initialize(teban: nil)
      @teban = teban
      @hand_pieces = []
    end

    def sente?
      teban == Teban::SENTE
    end

    def gote?
      teban == Teban::GOTE
    end

    def capture_piece(piece)
      @hand_pieces << piece
    end
  end

  class NonPlayer < Player
  end
end
