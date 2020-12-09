require "minitest/autorun"
require "minitest/pride"

require_relative "day09.rb"

class TestDeXMAS < Minitest::Test
  def test_weakness_25
    preamble = (1..25).to_a
    input = (preamble.concat([26,49,100])).join("\n")
    d = DeXMAS.new preamble: 25, input: input
    assert_equal 100, d.weakness
  end

  def test_weakness_not_same
    preamble = (1..25).to_a

    input = (preamble.concat([26,49,50])).join("\n")
    d = DeXMAS.new preamble: 25, input: input
    assert_equal 50, d.weakness
  end

  def test_weakness_previous_not_again
    preamble = (1..25).to_a
    input = (preamble.concat([45,66])).join("\n")
    d = DeXMAS.new preamble: 25, input: input
    refute d.weakness
  end

  def test_weakness
    input = <<~EOS
    35
    15
    25
    47
    40
    62
    55
    65
    95
    103
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
