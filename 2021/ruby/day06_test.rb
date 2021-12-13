#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day06"

class LaternFishCounterTest < Minitest::Test

  def test_laternfish_lifecycle
    fish = LanternFish.new 3
    fish.next_day!
    assert_equal 2, fish.timer 

    fish.next_day!
    assert_equal 1, fish.timer 

    fish.next_day!
    assert_equal 0, fish.timer 

    fish.next_day!
    assert_equal 6, fish.timer 

    fish.next_day!
    assert_equal 5, fish.timer 
  end

  def test_laternfish_reproduces
    fish = LanternFish.new 1
    assert_nil fish.next_day!

    new_fish = fish.next_day!
    refute_nil new_fish

    assert_equal 8, new_fish.timer
  end

  def test_population_simulates
    population = LanternFishPopulation.new [3,4,3,1,2]
    assert_equal 5, population.size

    population.next_day!
    assert_equal [2,3,2,0,1], population.timers

    population.next_day!
    assert_equal [1,2,1,6,0,8], population.timers

    population.next_day!
    assert_equal [0,1,0,5,6,7,8], population.timers
  end

  def test_population_runs_until
    population = LanternFishPopulation.new [3,4,3,1,2]

    population.run_days! 18
    assert_equal 26, population.size

    population = LanternFishPopulation.new [3,4,3,1,2]
    population.run_days! 80
    assert_equal 5934, population.size
  end

  def test_big_population
    skip "too slow"
    population = LanternFishPopulation.new [3,4,3,1,2]
    population.run_days! 256
    assert_equal 26984457539, population.size
  end
end

