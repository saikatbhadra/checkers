class Piece
  attr_reader :color
  attr_accessor :position

  TOP_MOVE_DIR = [[1,1],[1,-1]]
  BOTTOM_MOVE_DIR = [[-1,1],[-1,-1]]

  def initialize(color, position)
    @king = false
    @color = color
    @position = position
  end

  def valid_moves

  end

  def perform_slide
  end

  def perform_jump
  end

end
