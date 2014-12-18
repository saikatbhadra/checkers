require_relative 'tile'
require_relative 'piece'

# Class that contains physical items of chess (board & tiles)
class Board
  attr_accessor :grid, :tiles
  attr_reader :size

  def initialize(size = 8)
    raise "Can't have odd number of rows" unless size.even?
    @size = size

    @tiles = Array.new(@size) { Array.new(@size) { [] } }
    make_tiles

    @grid = Array.new(@size) { Array.new(@size) { nil } }
    add_pieces
  end

  def display_board
    grid.each_index do |i|
      grid.each_index do |j|
        if grid[i][j].nil?
          print "_\t"
        else
          (grid[i][j].color == :red) ? print("R\t") : print("W\t")
        end
      end
      print "\n\n"
    end
    puts
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


board = Board.new
board.display_board

puts "Moving piece"
board[2, 1].perform_slide([3, 0])
board.display_board

puts "Moving piece"
board[3, 0].perform_slide([4, 1])
board.display_board

puts "Moving piece"
board[5, 0].perform_jump([3, 2])
board.display_board

puts "Moving piece"
board[2, 3].perform_jump([4, 1])
board.display_board

# board[3, 0].perform_slide([4, 1])
# board.display_board
