#!/usr/bin/env ruby -w

class CrabMarines
  def initialize crabs, crab_math: false
    @crabs = crabs
    @crab_math = crab_math
  end

  def cost_for position
    @crabs.map { |curr|
      (curr-position).abs * rate(position)
    }.sum
  end

  def rate position
    @crab_math ? (position+1) : 1 
  end

  def cheapest_fuel
    0.upto(@crabs.size).map { |position| cost_for position }.min
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp.split(",").map(&:to_i)
  marines = CrabMarines.new input
  puts marines.cheapest_fuel
  marines = CrabMarines.new input, crab_math: true
  puts marines.cheapest_fuel
end
