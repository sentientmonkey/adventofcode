#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day05.rb"

class Test < Minitest::Test
  def setup
  end

  def test_row
    assert_equal 44, row("FBFBBFF")
  end

  def test_column
    assert_equal 5, col("RLR")
  end

  def test_seat
    assert_equal 357, seat("FBFBBFFRLR")
    assert_equal 567, seat("BFFFBBFRRR")
    assert_equal 119, seat("FFFBBBFRRR")
    assert_equal 820, seat("BBFFBBFRLL")
  end

  def test_max_seat
    input = <<~EOS
    FBFBBFFRLR
    BFFFBBFRRR
    FFFBBBFRRR
    BBFFBBFRLL
    EOS

    assert_equal 820, seat_max(input)
  end
end
 
