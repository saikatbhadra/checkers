require 'io/console'
require_relative 'coord'
require_relative 'board'

class Cursor
  attr_accessor :position, :board, :size

  def initialize(size)
    @position = [0,0]
    @size = size
  end

  def get
    while true
      chr = read_char
      offset = arrow_val(chr)
      offset
      if offset
        new_position = Coord.sum(position, offset)
        if in_range?(new_position)
          self.position = new_position
          p position
        end
      end
      break if done?(chr)
    end

    position
  end

  # Reads keypresses from the user including 2 and 3 escape character sequences.
  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
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

    def done?(chr)
      if (chr == "\e") || (chr == "\r")
        true
      else
        false
      end
    end

end
