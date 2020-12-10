require "minitest/autorun"
require "minitest/pride"

require_relative "day10.rb"

class TestDay < Minitest::Test
  def setup
    input = <<~EOS
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    EOS

    @joltage = JoltageAdapter.new input
  end

  def test_max
    assert_equal @joltage.rating, 22
  end

  def test_adapter
    assert_equal 0, @joltage.adapters[0]
    assert_equal 1, @joltage.adapters[1]
    assert_equal 4, @joltage.adapters[2]
    assert_equal 5, @joltage.adapters[3]
    assert_equal 22, @joltage.adapters.last
  end

  def test_diffs
    assert_equal 1, @joltage.diffs[0]
    assert_equal 3, @joltage.diffs[1]
    assert_equal 1, @joltage.diffs[2]
  end

  def test_tally
    assert_equal 7, @joltage.tally[1]
    assert_equal 5, @joltage.tally[3]
  end

  def test_product
    assert_equal 35, @joltage.product
  end

  def test_arrangements
    assert_equal 8, @joltage.arrangments
  end

  def test_larger
    input = <<~EOS
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    EOS

    joltage = JoltageAdapter.new input
    assert_equal 220, joltage.product
    assert_equal 19208, joltage.arrangments
  end
end
