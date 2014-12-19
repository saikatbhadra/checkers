require_relative 'cursor'
require 'byebug'

class HumanPlayer
  attr_accessor :color,:cursor
  attr_reader :name, :board

  def initialize(name)
    @name = name
  end

  def board=(board)
    # set cursor when player is fed board
    @board = board
    self.cursor = Cursor.new(board.size)
  end

  def get_moves
    puts "Select a position with <ENTER>."
    puts "Submit all your moves with another d"

    moves = []
    chr = nil
    while true
      puts "Selected moves: #{moves}"
      chr = get_move
      break if chr == 'd'
      moves << cursor.position unless cursor.position == moves.last
    end

    moves
  end

  # grabs a single move & returns last chr
  def get_move
    while true
      board.display_board(cursor.position)
      puts
      chr = cursor.update_position
      break if chr == "\r" || chr == "\d" || chr == 'q'
    end

    raise "User quit game" if chr == 'q'
    chr
  end
end
