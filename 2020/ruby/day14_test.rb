require "minitest/autorun"
require "minitest/pride"

require_relative "day14.rb"

class TestTimetable < Minitest::Test
  def test_bitmask
    port = Port.new
    port.mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
    assert_equal 73, port.bmask(11)
    assert_equal 101, port.bmask(101)
    assert_equal 64, port.bmask(0)
  end

  def test_save
    port = Port.new
    port.mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
    port[8] = 11
    assert_equal 73, port[8]
    port[7] = 101
    assert_equal 101, port[7]
    port[8] = 0
    assert_equal 64, port[8]
  end

  def test_checksum
    input = <<~EOS
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    EOS
    port = Port.new input
    assert_equal 165, port.checksum
  end
end
