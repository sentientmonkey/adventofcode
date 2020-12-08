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
    gb = Gameboy.new "jmp +2\nacc +4"
    gb.run
    assert_equal gb.acc, 0
    assert_equal gb.pos, 2
  end

  def test_stops_in_infite_loop
    gb = Gameboy.new @program
    gb.run
    assert_equal gb.acc, 5
  end

  def test_does_not_halt
    gb = Gameboy.new @program
    gb.run
    refute gb.halt?
  end

  def test_gameboy_debugger_patch
    gbd = GameboyDebugger.new @program
    gbd.patch 7,:nop
    assert gbd.halt?
    assert_equal 8, gbd.acc
  end

  def test_gameboy_debugger_find_patch
    gbd = GameboyDebugger.new @program
    gbd.run
    assert_equal 8, gbd.acc
    assert_equal 7, gbd.patch_pos
  end
end
