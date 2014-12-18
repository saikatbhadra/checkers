require_relative 'tile'
require_relative 'piece'

class Board
  attr_accessor :grid, :tiles
  attr_reader :size

  def initialize(size = 8)
    raise "Can't have odd number of rows" unless size.even?
    @size = size

    @tiles = Array.new(@size) { Array.new(@size) { [] } }
    make_tiles

    @grid = Array.new(@size) { Array.new(@size) { [] } }
    add_pieces
  end

  private
    def make_tiles
      size.times do |i|
        size.times do |j|
          tile_color = (i + j).even? ? :white : :black
          @tiles[i][j] = Tile.new(tile_color,[i,j])
        end
      end
    end

    def add_pieces
      no_man_rows = [size / 2 - 1, size / 2]

      size.times do |row|
        next if no_man_rows.include?(row)
        size.times do |col|
          piece_color = (row < no_man_rows[0]) ? :white : :red
          if tiles[row][col].color == :black
            grid[row][col] = Piece.new(piece_color, [row,col], self)
          end
        end
      end
    end
end

x = Board.new
p x
