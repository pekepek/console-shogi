# frozen_string_literal: true

module ConsoleShogi
  class Player
    module Teban
      SENTE = :sente
      GOTE = :gote
    end

    attr_reader :teban, :komadai

    def initialize(teban: nil)
      @teban = teban
      # TODO Komadai, Piece, Player が循環してる
      @komadai = Komadai.new
    end

    def sente?
      teban == Teban::SENTE
    end

    def gote?
      teban == Teban::GOTE
    end

    def capture_piece!(piece)
      @komadai.expand! unless komadai.have_space?

      piece.change_player!(self)
      komadai.put(piece: piece)
    end
  end

  class NonPlayer < Player
  end
end
