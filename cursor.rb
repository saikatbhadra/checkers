require_relative 'coord'
require_relative 'console'

# cursor object which stays in bounding square box  [(0...size), (0...size)]
# todo rename this class
class Cursor
  attr_accessor :position, :board, :size

  def initialize(size)
    @position = [0, 0]
    @size = size
  end

  # update cursor position based on arrow keys from user
  def update_position
    chr = Console.read_char

    offset = arrow_val(chr)
    if offset
      new_position = Coord.sum(position, offset)
      self.position = new_position if in_range?(new_position)
    end

    chr
  end

  private
    def in_range?(new_position)
      new_position.all? { |x| (0...size) === x }
    end

    def arrow_val(chr)
      case chr
      when "\e[A" # UP
        [-1,0]
      when "\e[B" # DOWN
        [1,0]
      when "\e[C" # RIGHT
        [0,1]
      when "\e[D" # LEFT
        [0,-1]
      else
        nil
      end
    end
end
