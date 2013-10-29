class Minesweeper

  def initialize(dimensions, mine_count)
    @dimensions = dimensions
    @board = Board.new(dimensions, mine_count)
  end

  def play

    until win? || lose?
      print "lose" if lose?
      @board.print_board
      move = get_move
      target_x, target_y = move[:coords]
      target_space = @board.board[target_x][target_y]

      move[:flag] ? flag_space(target_space) : reveal_space(target_space)

      unless move[:flag]
        reveal_neighbors(target_space) if target_space.mine_neighbors == 0
      end
    end

    @board.print_board

    puts win? ? "You won, boss!" : "You lose, you are no longer the boss."
  end

  def reveal_neighbors(space)
    neighbors = space.get_neighbors(@board.board, @dimensions)
    neighbors.select! { |n| !n.discovered }
    neighbors.each do |neighbor|
      reveal_space(neighbor) unless neighbor.mine
      reveal_neighbors(neighbor) if neighbor.mine_neighbors == 0
    end
  end

  def reveal_space(space)
    space.discovered = true
  end

  def flag_space(space)
    return if space.discovered
    space.flagged = space.flagged ? false : true
  end

  def mine?(space)
    space.mine
  end

  def lose?
    @board.board.any? do |row|
      row.any? do |space|
        space.mine && space.discovered
      end
    end
  end

  def win?
    @board.board.all? do |row|
      row.all? do |space|
        (!space.mine && space.discovered) || space.mine
      end
    end
  end


  def get_move
    move = {}
    puts "Where would you like to move, boss"
    move_input = gets.chomp.downcase.split(" ")
    move[:flag] = move_input[0] == "f" ? true : false
    move[:coords] = [(move_input[-1].to_i) -1 , (move_input[-2].to_i) -1]
    #validate
    move
  end
end

class Board
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
        board[row][space].mine_neighbors = mine_count
        board[row][space].mark = mine_count.to_s unless mine_count == 0
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
        symbol = space.discovered ? space.mark : "*"
        symbol = space.flagged ? "F" : symbol
        print "#{symbol} "
      end
      puts ""
    end

    nil
  end

end

class Space
  attr_accessor :mine, :mine_neighbors, :mark, :discovered, :coords, :flagged

  def initialize(coords, mine, mark)
    @discovered = false
    @mine = mine
    @mine_neighbors = 0
    @coords = coords
    @mark = mark #get_symbol
    @flagged = false
  end

  def get_neighbors(board, dimensions)
    neighbors = []

    neighbors_offset = [
      [-1, -1], [0, -1], [1, -1],
      [-1,0], [1,0],
      [-1, 1], [0, 1], [1, 1]
    ]

    neighbors_offset.each do |x,y|
      x_coord, y_coord = (@coords[0] + x), (@coords[1] + y)
      neighbors << board[x_coord][y_coord] if on_board?([x_coord, y_coord], dimensions)
    end

    neighbors
  end

  def on_board?(coords, dimensions)
    coords.all? { |num| num.between?(0, dimensions - 1) }
  end


end

game = Minesweeper.new(10, 20)
game.play