#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day05.rb"

class ComputerTest < Minitest::Test
  def setup
    @subject = Computer
  end

  def assert_program expected, source
    program = @subject.compile source
    r = @subject.run program
    assert_equal expected, r[0]
  end

  def assert_output expected, source
    program = @subject.compile source
    r = @subject.run program
    assert_equal expected, r[1]
  end

  def assert_input expected, source, input
    program = @subject.compile source
    r = @subject.run program, input
    assert_equal expected, r[0]
  end

  def test_intcode_adds
    assert_program [1,0,0,2,99], "1,0,0,3,99"
  end

  def test_intcode_stops_at_halt
    assert_program [99,1,0,0,3], "99,1,0,0,3"
  end

  def test_intcode_multiplies
    assert_program [2,0,0,4,99], "2,0,0,3,99"
  end

  def test_intcode_stores
    assert_input [1,0,99], "3,0,99", 1
  end

  def test_intcode_outputs
    assert_program [4,2,99], "4,2,99"
    assert_output [99], "4,2,99"
  end

  def test_position_arguments
    assert_program [1002,4,3,4,99], "1002,4,3,4,33"
  end

  def test_negative
    assert_program [1101,100,-1,4,99], "1101,100,-1,4,0"
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
