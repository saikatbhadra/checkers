require_relative 'board'
require_relative 'human_player'

class Game
  attr_accessor :cur_player, :players, :cursor
  attr_reader :board

  def initialize(player1, player2)
    # create the board
    @board = Board.default_board

    # create an array of players, set their colors & show them the board
    @players = [player1, player2]
    @players[0].color = :red
    @players[1].color = :white
    player1.board = board
    player2.board = board
  end

  def play
    until board.over?
      switch_players
      begin
        show_player_info
        path = current_player.get_moves
        execute_moves(path)
      rescue InvalidMoveError => e
        puts e.message
        puts "Invalid move. Please try again."
        retry
      end
      board.display_board
    end
    winning_color = board.winner
    if players[0].color == winning_color
      player_won = players[0]
    else
      player_won = players[1]
    end

    puts "Game over."
    puts "#{player_won.name} won!"
  end

  def show_player_info
    puts "Player Turn: #{current_player.name}"
    puts "Your color is: #{current_player.color}"
  end

  def switch_players
    players.reverse!
  end

  def execute_moves(moves)
    board[*moves[0]].perform_moves(moves[1..-1])
  end

  def current_player
    players.first
  end
end

if __FILE__ == $PROGRAM_NAME
  my_game = Game.new(HumanPlayer.new("Agent Smith"), HumanPlayer.new("Neo"))
  my_game.play
end
