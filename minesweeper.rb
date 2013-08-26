class Minesweeper

  def initialize(dimensions, mine_count)
    @dimensions = dimensions
    @mine_count = mine_count
    @board = populate_board
  end

  def populate_board
    board = Array.new(@dimensions) { Array.new(@dimensions) { Space.new } }
    placed_mines = 0

    until placed_mines == @mine_count
      candidate = board.sample.sample

      next if candidate.mine
      candidate.mine = true
      placed_mines += 1
    end
    board
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
  def initialize
    @discovered = false
    @mine = false
    @mine_neighbors = 0
    @print = get_symbol
  end

  def get_symbol
    if @discovered

    else
      "*"
    end

  end

end

