#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day05"

class VentMapperTest < Minitest::Test
  INPUT = <<~EOS
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
  EOS

  def assert_contains(mapper,x,y)
    assert mapper.contains?(x, y), "does not contain #{x},#{y}"
  end

  def test_marks_points
    mapper = VentMapper.new INPUT
    assert mapper.contains? 0, 9
    assert mapper.contains? 3, 4
  end

  def test_follows_horizontal_line
    mapper = VentMapper.new INPUT
    0.upto(5).each do |x|
      assert_contains mapper, x, 9
    end
    3.downto(1).each do |x|
      assert_contains mapper, x, 4
    end
  end

  def test_follows_vertical_line
    mapper = VentMapper.new INPUT
    0.upto(4).each do |y|
      assert_contains mapper, 7, y
    end
  end

  def test_count_vents
    mapper = VentMapper.new INPUT
    assert_equal 2, mapper.vents(0,9)
    assert_equal 1, mapper.vents(3,9)
    assert_equal 0, mapper.vents(0,0)
  end

  def test_overlaps
    mapper = VentMapper.new INPUT
    assert_equal 5, mapper.overlaps
  end

  def test_diagnals
    mapper = VentMapper.new INPUT, diagnals: true
    assert_contains mapper, 8, 0 
    assert_contains mapper, 0, 8
    assert_equal 12, mapper.overlaps
  end
end
