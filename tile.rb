class Tile
  attr_reader :color
  attr_accessor :piece, :position

  def initialize(color, position)
    @color = color
    @position = position
  end

end
