class Piece
  attr_reader :color
  attr_accessor :position

  TOP_MOVE_DIR = [[1,1],[1,-1]]
  BOTTOM_MOVE_DIR = [[-1,1],[-1,-1]]

  def initialize(color, position, board)
    @king = false
    @color = color
    @position = position
    @move_dir = (color == :white) ? TOP_MOVE_DIR : BOTTOM_MOVE_DIR
    @board = board
  end

  def inspect
    {
      :king => @king,
      :color => @color,
      :position => @position,
      :move_dir => @move_dir,
      :board => @board.object_id
    }.inspect
  end


  def perform_slide(new_pos)
    return false unless tile.piece # return false if tile is not empty
    
  end

  def valid_moves

  end


  def perform_jump(tile)

  end

end
