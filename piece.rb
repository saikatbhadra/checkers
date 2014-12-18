class Piece
  attr_reader :color, :move_dir
  attr_accessor :position, :board

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


  def perform_slide(new_position)
    raise "WTF" unless valid_slides.include?(new_position)

    # update position
    board[position] = nil
    board[*new_position] = self
    position = new_position
  end

  def valid_slides
    slides = []
    move_dir.each do |offset|
      possible_move = [offset[0] + position[0], offset[1] + position[1]]
      if board.on_board?(possible_move) && board[*possible_move].nil?
        slides << possible_move
      end
    end

    slides
  end

  def perform_jump(tile)

  end

end
