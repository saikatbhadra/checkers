require_relative 'board'
require_relative 'human_player'

class Game
  attr_accessor :cur_player, :players
  attr_reader :board

  def initialize(player1, player2)
    @board = Board.default_board
    @players = [player1, player2]
    @players[0].color = :red
    @players[1].color = :white
  end

  def play
    until board.over?
      switch_players
      display_info

      position, moves = current_player.get_moves
      p moves
      p position
      execute_moves(moves, position)
    end
  end

  def display_info
    puts "Player Turn: #{current_player.name}"
    puts "Color: #{current_player.color}"
    board.display_board
  end

  def switch_players
    players.reverse!
  end

  def execute_moves(moves, position)
    # raise "Wrong piece" if board[*position].color != cur_player.color
    # nEED TO WRITE ALL THE LOGIC AGAIN???
    board[*position].perform_moves(moves)
  end

  def current_player
    players.first
  end

end

if __FILE__ == $PROGRAM_NAME
  my_game = Game.new(HumanPlayer.new("Agent Smith"), HumanPlayer.new("Neo"))
  my_game.play
end
