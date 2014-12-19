require_relative 'coord'
require 'byebug'
class InvalidMoveError <  StandardError

end

class Piece
  attr_accessor :color
  attr_accessor :position, :board, :king, :move_dir # make method

  TOP_MOVE_DIR = [[1, 1], [1, -1]]
  BOTTOM_MOVE_DIR = [[-1, 1], [-1, -1]]

  def initialize(color, position, board)
    @king = false
    @color = color
    @position = position
    @board = board
  end

  def move_dir
    move_dir = (color == :white) ? TOP_MOVE_DIR : BOTTOM_MOVE_DIR
    if king
      new_move_dir = move_dir.map { |coord| [-1 * coord[0], coord[1]] }
      move_dir += new_move_dir
    end

    move_dir
  end

  def dup(board)
    duped_piece = Piece.new(color, position, board)
    duped_piece.move_dir = move_dir
    duped_piece.king = king
    duped_piece
  end

  def inspect
    {
      :king => @king,
      :color => @color,
      :position => @position,
      :move_dir => move_dir,
      :board => @board.object_id
    }.inspect
  end

  def perform_moves(move_sequence)
    p move_sequence
    if valid_move_seq?(move_sequence)
      perform_moves_without_check(move_sequence)
    else
      raise InvalidMoveError.new("Invalid move sequence")
    end
  end

  def valid_move_seq?(move_sequence)
    begin
      new_board = board.dup
      new_board[*position].perform_moves_without_check(move_sequence)
    rescue InvalidMoveError
      return false
    end

    true
  end

  def perform_moves_without_check(move_sequence)
    if move_sequence.length == 1
      move_happened = perform_slide(move_sequence.first)
      move_happened = perform_jump(move_sequence.first) unless move_happened
      unless move_happened
        raise InvalidMoveError.new("Move from #{position} to #{move_sequence.first} not valid!")
      end
    else
      move_sequence.each do |move|
        move_happened = perform_jump(move)
        unless move_happened
          raise InvalidMoveError.new("Move from #{position} to #{move} not valid!")
        end
      end
    end
  end

  def perform_slide(new_position)
    return false unless valid_slides.include?(new_position)

    board.remove_piece(position) # remove off board
    board.add_piece(self, new_position) #add back to board
    maybe_promote
    true
  end

  def opponent?(opp_piece)
    opp_piece.color != self.color
  end

  def king_row?
    king_row = (color == :white) ? board.size - 1 : 0
    position[0] == king_row
  end

  def perform_jump(new_position)
    possible_jumps, possible_eats = valid_jumps_and_eats
    return false unless possible_jumps.include?(new_position)

    # update position
    board.remove_piece(position) # remove off board
    board.add_piece(self, new_position) # add back to board

    # remove the piece that has been eaten
    eat_position = possible_eats[possible_jumps.index(new_position)]
    board.remove_piece(eat_position)
    maybe_promote
    true
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
        self.king = true
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
