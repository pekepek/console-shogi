# frozen_string_literal: true

require_relative 'console_shogi/version'
require_relative 'console_shogi/game'
require_relative 'console_shogi/board'
require_relative 'console_shogi/terminal_operator'
require_relative 'console_shogi/piece'
require_relative 'console_shogi/boards'
require_relative 'console_shogi/piece_mover'

module ConsoleShogi
  class Error < StandardError; end

  def self.game_start
    Game.new.start
  end
end
