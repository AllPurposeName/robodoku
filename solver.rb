class Solver
  attr_reader :board

  def initialize
    @board = []
    @solution = []
  end

  def board_intake(boardfile)
    @board = []
    File.readlines(boardfile).each do |line|
      game_row = line.delete("\n").split("")
      game_row.each_with_index { |number_string, index| game_row[index] = number_string.to_i}
      @board << game_row
    end
    self.spot_make
  end

  def spot_make
    @board.each_with_index do |row, row_index|
      row.each_with_index {|entry, column_index| row[column_index] = Spot.new(row_index, column_index, self.square_finder(row_index, column_index)) if entry == 0}
    end
  end

  def column_make(column_number)
    column_array = []
    @board.each {|row| column_array << row[column_number]}
    column_array
  end

  def square_make(square_number)
    case square_number
    when 1..3
      top_arrays = @board[0..2]
      self.squarer(square_number, top_arrays)
    when 4..6
      mid_arrays = @board[3..5]
      self.squarer(square_number, mid_arrays)
    when 7..9
      bottom_arrays = @board[6..8]
      self.squarer(square_number, bottom_arrays)
    end
  end


  def squarer(square_number, array_set)
    squared_array = []
    case square_number
    when 1, 4, 7 then array_set.each {|a| squared_array << a[0..2]}
    when 2, 5, 8 then array_set.each {|a| squared_array << a[3..5]}
    when 3, 6, 9 then array_set.each {|a| squared_array << a[6..8]}
    end
    squared_array.flatten
  end

  def square_finder(row_index, column_index)
    case row_index
    when 0..2
      case column_index
        when 0..2 then 1
        when 3..5 then 2
        when 6..8 then 3
      end
    when 3..5
      case column_index
        when 0..2 then 4
        when 3..5 then 5
        when 6..8 then 6
      end
    when 6..8
      case column_index
        when 0..2 then 7
        when 3..5 then 8
        when 6..8 then 9
      end
    end
  end

  def candidate_delete(spot, chunk)
    spot.candidates = spot.candidates.reject {|x| chunk.include?(x)}
  end

  def chunk_check(spot)
    self.candidate_delete(spot, @board[spot.row_index])
    self.candidate_delete(spot, column_make(spot.column_index))
    self.candidate_delete(spot, square_make(spot.square))
  end

  def candidate_alone?(spot)
    spot.candidates.length == 1
  end

  def spot_remove(spot)
    @board[spot.row_index][spot.column_index] = spot.candidates[0]
  end


  def spot_scan
    until self.board_clean?
      @board.each do |row|
        row.each { |entry| self.sudoku_solve(entry) if entry.is_a?(Spot) }
      end
    end
  end

  def board_solved?
      @board.flatten.reduce(:+) == 405 ? puts("Solution correct. You just got robodoku'd.") : puts("Loser.")
  end

  def board_clean?
    !@board.flatten.include?(Spot)# ? self.board_solved? : nil
  end

  def sudoku_solve(entry)
      self.chunk_check(entry)
      self.spot_remove(entry) if candidate_alone?(entry)
  end
end


    # chunk_check to reduce cands by row, square, column
    # scan through spots and spot_remove
    # somehow scan and check if cands no longer decreasing
    # then
    # do harder algorithm to reduce cands further
    #  then
    # prior algorithm


class Spot
  attr_accessor :candidates
  attr_reader :row_index, :column_index, :square

  def initialize(row_index, column_index, square)
    @row_index = row_index
    @column_index = column_index
    @square = square
    @candidates = (1..9).to_a
  end
end
