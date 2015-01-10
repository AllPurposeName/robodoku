require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require './solver.rb'
require 'byebug'

class SolverTest < MiniTest::Test

  def setup
    @solver = Solver.new
    @solver.board_intake("board_2.txt")
    @solver.spot_make
  end

  def test_it_exists
    assert @solver
  end

  def test_it_has_a_board_instance_variable
    skip
    puts @solver.board[0]
  end

  def test_it_finds_the_right_square
    assert_equal 3, @solver.square_finder(0, 6)
    assert_equal 5, @solver.square_finder(3, 3)
    assert_equal 8, @solver.square_finder(8, 3)
  end

  def test_column_includes_spot_number_and_not_number
    @solver.board_intake("board_4.txt")
    result_column = @solver.column_make(4)
    refute result_column.include?(7)
    assert result_column.include?(8)
    assert result_column[1].is_a?(Spot)
  end

  def test_row_includes_spot_number_and_not_number
    @solver.board_intake("board_4.txt")
    row = @solver.board[2]
    refute row.include?(5)
    assert row.include?(3)
    assert row[7].is_a?(Spot)
  end

  def test_square_includes_spot_number_and_not_number
    @solver.board_intake("board_4.txt")
    result_square = @solver.square_make(4)
    refute result_square.include?(5)
    assert result_square.include?(7)
    assert result_square[4].is_a?(Spot)
  end

  def test_solver_candidate_delete_arrays
    spot = Spot.new(nil,nil,nil)
    assert_equal [4,5,6,7,8,9], @solver.candidate_delete(spot,[1,2,3])
    assert_equal [4,5,6,7,8,9], spot.candidates
  end

  def test_it_evaluates_a_given_spot_and_given_row
    spot = @solver.board[0][1]
    @solver.candidate_delete(spot, @solver.board[0])
  end

  def test_it_chunk_checks
    @solver.board_intake("board_3.txt")
    candidates_left = []
    candidates_left << @solver.chunk_check(@solver.board[0][1])
    candidates_left << @solver.chunk_check(@solver.board[1][4])
    candidates_left << @solver.chunk_check(@solver.board[2][7])
    candidates_left << @solver.chunk_check(@solver.board[3][5])
    candidates_left << @solver.chunk_check(@solver.board[4][1])
    assert_equal [9,7,5,1,5], candidates_left.flatten
  end

  def test_it_removes_a_spot_correctly
    @solver.board_intake("board_3.txt")
    @solver.chunk_check(@solver.board[0][1])
    assert_equal 9, @solver.spot_remove(@solver.board[0][1])
  end

  def test_it_solves_Jeffs_board
    @solver.board_intake("board_4.txt")
    @solver.spot_scan
    assert @solver.board_clean?
    byebug
  end
end
