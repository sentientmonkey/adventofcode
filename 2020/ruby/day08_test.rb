require "minitest/autorun"
require "minitest/pride"

require_relative "day08.rb"

class TestGameboy < Minitest::Test
  def setup
    @program = <<~EOS
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    EOS
  end

  def test_parse
    gb = Gameboy.new "nop +0\nacc -1\njmp +4"
    assert_equal gb.stack, [[:nop, 0], [:acc, -1], [:jmp, 4]]
  end

  def test_noop_skips
    gb = Gameboy.new "nop +0"
    gb.run
    assert_equal gb.acc, 0
    assert_equal gb.pos, 1
  end

  def test_acc_increments
    gb = Gameboy.new "acc +4"
    gb.run
    assert_equal gb.acc, 4
    assert_equal gb.pos, 1
  end

  def test_jmp_skips
    gb = Gameboy.new "jmp +1\nacc +4"
    gb.run
    assert_equal gb.acc, 0
    assert_equal gb.pos, 2
  end

  def test_stops
    gb = Gameboy.new @program
    gb.run
    assert_equal gb.acc, 5
  end
end
 
