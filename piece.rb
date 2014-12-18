require_relative 'coord'

class Piece
  attr_reader :color
  attr_accessor :position, :board, :king, :move_dir

  TOP_MOVE_DIR = [[1, 1], [1, -1]]
  BOTTOM_MOVE_DIR = [[-1, 1], [-1, -1]]

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
    return false unless valid_slides.include?(new_position)

    # update position
    board[*position] = nil
    board[*new_position] = self
    self.position = new_position
    maybe_promote
  end

  def opponent?(opp_piece)
    opp_piece.color != self.color
  end

  def king_row?
    king_row = (move_dir.first.first == 1) ? board.size - 1 : 0
    position[0] == king_row
  end

  def perform_jump(new_position)
    possible_jumps, possible_eats = valid_jumps_and_eats
    return false unless possible_jumps.include?(new_position)

    # update position
    board[*position] = nil
    board[*new_position] = self
    self.position = new_position

    # remove the piece that has been eaten
    eat_position = possible_eats[possible_jumps.index(new_position)]
    board[*eat_position].position = nil
    board[*eat_position] = nil
    maybe_promote
  end

  private
    def valid_slides
      slides = []
      move_dir.each do |offset|
        possible_move = Coord.sum(offset, position)
        if board.on_board?(possible_move) && board[*possible_move].nil?
          slides << possible_move
        end
      end

      slides
    end

    def maybe_promote
      return if king
      if king_row?
        king = true
        new_move_dir = move_dir.map { |coord| [-1 * coord[0], coord[1]] }
        move_dir += new_move_dir
      end
    end

    def valid_jumps_and_eats
      jumps = []
      eats = []
      move_dir.each do |offset|
        eat_position = Coord.sum(position, offset)
        land_position = Coord.sum(eat_position, offset)

        next unless board.on_board?(land_position) # check if still on board
        next if board[*eat_position].nil?
        next unless opponent?(board[*eat_position])

        if board[*land_position].nil?
          jumps << land_position
          eats << eat_position
        end
      end

      return jumps, eats
    end
end
