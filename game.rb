require_relative 'board'

class Game

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
