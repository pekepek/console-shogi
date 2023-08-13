# frozen_string_literal: true

require_relative 'terminal/display_area'
require_relative 'terminal/drawer'
require_relative 'terminal/cursor'

module ConsoleShogi
  class Terminal
    attr_reader :cursor, :drawer, :selected_cursor, :last_cursor_on_grid

    def initialize
      @cursor = Cursor.new
      # @drawer = Drawer.new
      Drawer.cursor = cursor

      @selected_cursor = nil
      @last_cursor_on_grid = nil
    end

    def move_cursor!(key)
      @last_cursor_on_grid = cursor.dup unless cursor.grid_position.location.outside?

      cursor.move!(key)

      Drawer.cursor = cursor
    end

    def select_cursor!
      @selected_cursor = cursor.dup
    end

    def deselect_cursor!
      @selected_cursor = nil
    end
  end
end
