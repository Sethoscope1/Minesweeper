class Minesweeper

  def initialize(dimensions, mine_count)
    @dimensions = dimensions
    @board = Array.new(dimensions) { Array.new(dimensions) { Space.new } }
    @mine_count = mine_count
  end

  def print_board
    @board.each do |row|
      row.each do |space|
        print space.print + " "
      end
      puts ""
    end
    nil
  end

end

class Space
  attr_accessor :mine, :mine_neighbors, :print
  #bomb/ empty
  # bomb_neighbors count
  # sym =
  # state = discovered
  #
  def initialize
    @discovered = false
    @mine = false
    @mine_neighbors = 0
    @print = "*"
  end

  def get_neighbors

  end

end