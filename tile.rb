class Tile
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def inspect
    "Tile: #{self.object_id}, color:#{color}"
  end
end
