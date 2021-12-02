#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day02.rb"

class SubmarineTest < Minitest::Test

  def test_movement
    sub = Submarine.new
    assert_equal 0, sub.position 
    assert_equal 0, sub.depth 

    sub.move :forward, 5
    assert_equal 5, sub.position 
    assert_equal 0, sub.depth 

    sub.move :down, 10
    assert_equal 5, sub.position 
    assert_equal 10, sub.depth 

    sub.move :up, 3
    assert_equal 5, sub.position 
    assert_equal 7, sub.depth 

    assert_equal 35, sub.coord
  end

  def test_plot_course
    sub = Submarine.new
    course = <<~EOS
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
    EOS

    sub.plot_course course

    assert_equal 150, sub.coord
  end

  def test_aiming_sub
    sub = AimingSubmarine.new
   
    assert_equal 0, sub.position 
    assert_equal 0, sub.depth 
    assert_equal 0, sub.aim

    sub.move :forward, 5
    assert_equal 5, sub.position 
    assert_equal 0, sub.depth 
    assert_equal 0, sub.aim

    sub.move :down, 5
    assert_equal 5, sub.position 
    assert_equal 0, sub.depth 
    assert_equal 5, sub.aim

    sub.move :forward, 8
    assert_equal 13, sub.position 
    assert_equal 40, sub.depth 
    assert_equal 5, sub.aim

    sub.move :up, 3
    assert_equal 13, sub.position 
    assert_equal 40, sub.depth 
    assert_equal 2, sub.aim
  end

  def test_plot_aiming_course
    sub = AimingSubmarine.new
    course = <<~EOS
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
    EOS

    sub.plot_course course

    assert_equal 900, sub.coord
  end
end
