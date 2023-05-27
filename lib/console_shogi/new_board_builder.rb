# frozen_string_literal: true

module ConsoleShogi
  class NewBoardBuilder
    class << self
      def build
        Board.new(
          pieces: [
            [
              Kyosha.new(teban: Teban::GOTE),
              Keima.new(teban: Teban::GOTE),
              Gin.new(teban: Teban::GOTE),
              Kin.new(teban: Teban::GOTE),
              Ohsho.new(teban: Teban::GOTE),
              Kin.new(teban: Teban::GOTE),
              Gin.new(teban: Teban::GOTE),
              Keima.new(teban: Teban::GOTE),
              Kyosha.new(teban: Teban::GOTE)
            ],
            [
              NonePiece.new,
              Hisha.new(teban: Teban::GOTE),
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              Kaku.new(teban: Teban::GOTE),
              NonePiece.new
            ],
            [
              Fu.new(teban: Teban::GOTE),
              Fu.new(teban: Teban::GOTE),
              Fu.new(teban: Teban::GOTE),
              Fu.new(teban: Teban::GOTE),
              Fu.new(teban: Teban::GOTE),
              Fu.new(teban: Teban::GOTE),
              Fu.new(teban: Teban::GOTE),
              Fu.new(teban: Teban::GOTE),
              Fu.new(teban: Teban::GOTE)
            ],
            [
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new
            ],
            [
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new
            ],
            [
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new
            ],
            [
              Fu.new(teban: Teban::SENTE),
              Fu.new(teban: Teban::SENTE),
              Fu.new(teban: Teban::SENTE),
              Fu.new(teban: Teban::SENTE),
              Fu.new(teban: Teban::SENTE),
              Fu.new(teban: Teban::SENTE),
              Fu.new(teban: Teban::SENTE),
              Fu.new(teban: Teban::SENTE),
              Fu.new(teban: Teban::SENTE)
            ],
            [
              NonePiece.new,
              Kaku.new(teban: Teban::SENTE),
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              NonePiece.new,
              Hisha.new(teban: Teban::SENTE),
              NonePiece.new
            ],
            [
              Kyosha.new(teban: Teban::SENTE),
              Keima.new(teban: Teban::SENTE),
              Gin.new(teban: Teban::SENTE),
              Kin.new(teban: Teban::SENTE),
              Ohsho.new(teban: Teban::SENTE),
              Kin.new(teban: Teban::SENTE),
              Gin.new(teban: Teban::SENTE),
              Keima.new(teban: Teban::SENTE),
              Kyosha.new(teban: Teban::SENTE)
            ]
          ]
        )
      end
    end
  end
end
