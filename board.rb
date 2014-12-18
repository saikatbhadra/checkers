require_relative 'tile'

class Board
  attr_accessor :grid
  attr_reader :size

  def initialize(size)
    @size = size
    @grid = Array.new(@size) { Array.new(@size) { [] } }
    make_tiles
  end

  def inspect
    board_array = Array.new(size) { Array.new(size) { [] } }

    board_array.each_index do |i|
      board_array.each_index do |j|
        board_array[i][j] = "Tile color:#{grid[i][j].color}"
      end
    end

    "Board: #{object_id} \n" + board_array.inspect
  end

  private

    def make_tiles
      grid.count.times do |i|
        grid.count.times do |j|
          if (i + j).even?
            @grid[i][j] = Tile.new(:black)
          else
            @grid[i][j] = Tile.new(:white)
          end
        end
      end
    end
end
