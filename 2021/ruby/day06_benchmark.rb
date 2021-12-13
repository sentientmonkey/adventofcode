#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/benchmark"

require_relative "day06"

class LanternFishPopulationBenchmark < Minitest::Benchmark
  def self.bench_range
    [1,10,100,1000]
  end

  def bench_population
    assert_performance_linear 0.99 do |n|
      population = LanternFishPopulation.new [3,4,3,1,2]
      population.run_days! n
    end
  end
end
