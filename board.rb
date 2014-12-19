require_relative 'tile'
require_relative 'piece'
require 'colorize'

class BoardMove <  StandardError

end

# Class that contains physical items of chess (board & tiles)
class Board
  attr_accessor :grid, :tiles
  attr_reader :size

  def initialize(size = 8)
    raise "Can't have odd number of rows" unless size.even?
    @size = size

    @grid = Array.new(@size) { Array.new(@size) { nil } }
    @tiles = Array.new(@size) { Array.new(@size) { [] } }
    make_tiles
  end

  def self.default_board(size = 8)
    default_board = Board.new(size)
    default_board.set_default_pieces
    default_board
  end

  def over?
    grid.flatten.all? { |el| el == nil }
  end

  def winner?(color)
    return false unless over?
    return true if grid.flatten.any? do |el|
      if el.nil?
        false
      elsif el.color == color
        true
      end
    end
    false
  end

  def set_default_pieces
    no_man_rows = [size / 2 - 1, size / 2]

    size.times do |row|
      next if no_man_rows.include?(row)
      size.times do |col|
        piece_color = (row < no_man_rows[0]) ? :white : :red
        if tiles[row][col].color == :black
          grid[row][col] = Piece.new(piece_color, [row, col], self)
        end
      end
    end
  end

  def add_piece(piece, new_position)
    unless self[*new_position].nil?
      raise BoardMove.new("Piece already exists here!")
    end
    self[*new_position]  = piece
    piece.position = new_position
  end

  def remove_piece(old_position)
    removed_piece = self[*old_position]
    if removed_piece.nil?
      raise BoardMove.new("No piece exists at location!")
    end

    self[*old_position]  = nil
    removed_piece.position = nil
  end

  def dup
    duped_board = Board.new(size)
    grid.each_index do |i|
      grid.each_index do |j|
        unless self[i,j].nil?
          duped_board[i,j] = self[i,j].dup(duped_board)
        end
      end
    end

    duped_board
  end

  def display_board(cursor_position = nil)
    grid.each_index do |i|
      grid.each_index do |j|
        background_color = (tiles[i][j].color == :black) ? :black : :light_white
        if grid[i][j].nil?
          if [i,j] == cursor_position
            print "$ $".colorize(:background => background_color).colorize(:color => :light_magenta).blink
          else
            print "   ".colorize(:background => background_color)
          end
        else
          # print "   ".colorize(:background => background_color)
          color = (grid[i][j].color == :red) ? :red : :light_white
          if [i,j] == cursor_position
            print "$".colorize(:color => :light_magenta).colorize(:background => background_color).blink
            print "O".colorize(:color => color).colorize(:background => background_color)
            print "$".colorize(:color => :light_magenta).colorize(:background => background_color).blink
          else
            print " O ".colorize(:color => color).colorize(:background => background_color)
          end
        end
      end
      print "\n"
    end
  end

  def inspect
    info = "Board: #{object_id}, size: #{size}\n"
    info + "Pieces:\n" + grid.inspect + "\n" #+ "Tiles:\n"  + tiles.inspect
  end

  def [](row, col)
    grid[row][col]
  end

  def []=(row, col, assign_val)
    grid[row][col] = assign_val
  end

  def on_board?(coord)
    (coord.all? { |el| (0...size) === el }) ? true : false
  end

  private
    def make_tiles
      size.times do |i|
        size.times do |j|
          tile_color = (i + j).even? ? :white : :black
          @tiles[i][j] = Tile.new(tile_color, [i, j])
        end
      end
    end
end
