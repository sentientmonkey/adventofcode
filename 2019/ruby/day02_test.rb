#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day02.rb"

class ComputerTest < Minitest::Test
  def setup
    @subject = Computer
  end

  def assert_program expected, source
    program = @subject.compile source
    stack = @subject.run program
    assert_equal expected, stack
  end

  def test_intcode_adds
    assert_program [1,0,0,2,99], "1,0,0,3,99"
  end

  def test_intcode_stops_at_halt
    assert_program [99,1,0,0,3], "99,1,0,0,3"
  end

  def test_incode_multiplies
    assert_program [2,0,0,4,99], "2,0,0,3,99"
  end

  def test_intcode_full_programs
    assert_program [3500,9,10,70,2,3,11,0,99,30,40,50], "1,9,10,3,2,3,11,0,99,30,40,50"

    assert_program [2,0,0,0,99], "1,0,0,0,99"
    assert_program [2,4,4,5,99,9801], "2,4,4,5,99,0"
    assert_program [30,1,1,4,2,5,6,0,99], "1,1,1,4,99,5,6,0,99"
  end

  def test_alter_program
    altered = @subject.alter_program [1,0,0,2,99], 12, 2
    assert_equal [1,12,2,2,99], altered
  end
end
