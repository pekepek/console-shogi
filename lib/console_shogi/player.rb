# frozen_string_literal: true

module ConsoleShogi
  class Player
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

    def win?
      komadai.pieces.any? {|p| p.class == Ohsho }
    end

    def win_image
      File.read("images/#{teban}/shori.png")
    end

    def capture_piece!(piece)
      piece.teban = teban
      komadai.put(piece: piece)
    end
  end
end
