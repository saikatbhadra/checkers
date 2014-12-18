require_relative 'tile'
require_relative 'piece'

class Board
  attr_accessor :grid
  attr_reader :size

  def initialize(size = 8)
    raise "Can't have odd number of rows" unless size.even?
    @size = size
    @grid = Array.new(@size) { Array.new(@size) { [] } }
    make_tiles
    add_pieces_to_tiles
  end

  def inspect
    # board_array = Array.new(size) { Array.new(size) { [] } }
    #
    # board_array.each_index do |i|
    #   board_array.each_index do |j|
    #     board_array[i][j] = board_#"Tile color:#{grid[i][j].color}"
    #   end
    # end

    "Board: #{object_id} \n" + grid.inspect
  end

  private
    def make_tiles
      grid.count.times do |i|
        grid.count.times do |j|
          tile_color = (i + j).even? ? :white : :black
          @grid[i][j] = Tile.new(tile_color,[i,j])
        end
      end
    end

    def add_pieces_to_tiles
      # set a piece on each part of the board
      no_man_rows = [size / 2 - 1, size / 2]

      size.times do |i|
        next if no_man_rows.include?(i)
        size.times do |j|
          piece_color = (i < no_man_rows[0]) ? :white : :red
          if grid[i][j].color == :black
            grid[i][j].piece = Piece.new(piece_color, [i,j])
          end
        end
      end
    end
end

x = Board.new
p x
