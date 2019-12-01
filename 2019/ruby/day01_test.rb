#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day01.rb"


#  For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
#  For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
#  For a mass of 1969, the fuel required is 654.
#  For a mass of 100756, the fuel required is 33583.

class RocketCalcTest < Minitest::Test
  def setup
    @subject = RocketCalc
  end

  def test_fuel
    assert_equal 2, @subject.fuel(12)
    assert_equal 2, @subject.fuel(14)
    assert_equal 654, @subject.fuel(1969)
    assert_equal 33583, @subject.fuel(100756)
  end

  def test_total_fuel
    assert_equal 658, @subject.total_fuel([12,14,1969])
  end

  def test_fuel_sums
    assert_equal [2], @subject.fuel_sums(14)
    assert_equal [654, 216, 70, 21, 5], @subject.fuel_sums(1969)
  end

  def test_fuel_extra
    assert_equal 2, @subject.fuel_extra(14)
    assert_equal 966, @subject.fuel_extra(1969)
  end
end
