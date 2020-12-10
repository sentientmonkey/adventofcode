require "minitest/autorun"
require "minitest/pride"

require_relative "day09.rb"

class TestDeXMAS < Minitest::Test

  def weakness range, next_number
    preamble = range.to_a.concat([next_number])
    puts preamble.inspect
    input = preamble.join("\n")
    d = DeXMAS.new preamble: preamble.size-1, input: input
    d.weakness
  end

  def assert_weakness range, next_number
    assert_equal weakness(range, next_number), next_number
  end

  def refute_weakness range, next_number
    refute weakness(range, next_number)
  end

  def test_weakness_25
    refute_weakness(1..25, 26)
    refute_weakness(1..25, 49)
    assert_weakness(1..25, 100)
    assert_weakness(1..25, 50)
  end

  def test_weakness
    input = <<~EOS
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    EOS

    d = DeXMAS.new preamble:5, input: input
    assert_equal 127, d.weakness
  end
end
