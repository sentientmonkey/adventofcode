#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day03.rb"

class PanelTest < Minitest::Test
  def setup
    @subject = Panel
  end

  def test_path_right
    result = @subject.path "R2"
    expected = [[1,0], [2,0]]
    assert_equal expected, result
  end

  def test_path_left
    result = @subject.path "L2"
    expected = [[-1,0], [-2,0]]
    assert_equal expected, result
  end

  def test_path_up
    result = @subject.path "U2"
    expected = [[0,1], [0,2]]
    assert_equal expected, result
  end

  def test_path_down
    result = @subject.path "D2"
    expected = [[0,-1], [0,-2]]
    assert_equal expected, result
  end

  def test_full_path
    result = @subject.path "R2,L2,U2,D2"
    expected = [[1,0], [2,0], [1,0], [0,0], [0,1], [0,2], [0,1], [0,0]]
    assert_equal expected, result
  end

  def test_distance
    crosses = [[3,3], [6,5]]
    result = @subject.minimum_distance crosses
    assert_equal 6, result
  end

  def assert_distance distance, route
    result = @subject.trace route
    assert_equal distance, result
  end

  def test_distances
    assert_distance 135, "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
    assert_distance 159, "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
  end
end
