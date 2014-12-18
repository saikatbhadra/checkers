# Helper module for coordinate operations
module Coord
  def self.sum(coord1, coord2)
    coord1.each_with_index.map { |el, i| el + coord2[i] }
  end
end
