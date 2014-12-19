class HumanPlayer
  attr_accessor :color
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_moves
    return [2,1],[[3,0]]
  end

end
