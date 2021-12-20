#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day07"

class CrabMarinesTest < Minitest::Test
  def test_fuel_cost
    marines = CrabMarines.new [16,1,2,0,4,2,7,1,2,14]

    assert_equal 37, marines.cost_for(2)
    assert_equal 41, marines.cost_for(1)
    assert_equal 39, marines.cost_for(3)
    assert_equal 71, marines.cost_for(10)
  end

  def test_cheapest_fuel
    marines = CrabMarines.new [16,1,2,0,4,2,7,1,2,14]

    assert_equal 37, marines.cheapest_fuel
  end

  def test_fuel_cost_crab_math
    marines = CrabMarines.new [16,1,2,0,4,2,7,1,2,14], crab_math: true

    assert_equal 168, marines.cost_for(5)
  end
end
