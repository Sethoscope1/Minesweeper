class Minesweeper
  attr_accessor :board
  attr_reader :dimensions

  def initialize(dimensions, mine_count)
    @dimensions = dimensions
    @mine_count = mine_count
    @board = populate_board
  end

  def populate_board
    board = Array.new(@dimensions) { Array.new(@dimensions) }
    placed_mines = 0

    #Populate board with mines
    until placed_mines == @mine_count
      row, space = random_coords

      candidate = board[row][space]

      next if !candidate.nil? && candidate.mine
      #must reset board here
      board[row][space] = Space.new([row,space], true, "o")
      placed_mines += 1
    end

    #Populate other spaces
    board.length.times do |row|
      board.length.times do |space|
        board[row][space] = Space.new([row,space], false, "_") unless board[row][space]

      end
    end

    #Add mine count to spaces
    board.length.times do |row|
      board.length.times do |space|
        #Skip to next space if this is a mine
        next if board[row][space].mine

        mine_count = 0
        neighbors = board[row][space].get_neighbors(board, dimensions)
        neighbors.each do |neighbor|
          mine_count += 1 if neighbor.mine
        end
        puts neighbors.length
        board[row][space].mine_neighbors = mine_count
        board[row][space].print = mine_count.to_s unless mine_count == 0
      end
    end

    board
  end

  def random_coords
    [(0...dimensions).to_a.sample, (0...dimensions).to_a.sample]
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

class Board
end

class Space
  attr_accessor :mine, :mine_neighbors, :print, :discovered, :coords

  def initialize(coords, mine, print)
    @discovered = true
    @mine = mine
    @mine_neighbors = 0
    @coords = coords
    @print = print #get_symbol
  end

  def get_neighbors(board, dimensions)
    neighbors = []

    neighbors_offset = [
      [-1, -1], [0, -1], [1, -1],
      [-1,0], [1,0],
      [-1, 1], [0, 1], [1, 1]
    ]

    puts "dimensions: #{dimensions}"

    neighbors_offset.each do |x,y|
      x_coord, y_coord = (@coords[0] + x), (@coords[1] + y)
      neighbors << board[x_coord][y_coord] if on_board?([x_coord, y_coord], dimensions)
    end

    neighbors
  end

  def on_board?(coords, dimensions)
    coords.all? { |num| num.between?(0, dimensions - 1) }
  end

  # def get_symbol
#     if discovered
#       if mine
#         "o"
#       else
#         "_"
#       end
#     else
#       "*"
#     end
#
#   end

end

