#!/usr/bin/env ruby -w

class CrabMarines
  def initialize crabs
    @crabs = crabs
  end

  def cost_for position
    @crabs.map {|curr| (curr-position).abs }.sum
  end

  def cheapest_fuel
    0.upto(@crabs.size).map { |position| cost_for position }.min
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp.split(",").map(&:to_i)
  marines = CrabMarines.new input
  puts marines.cheapest_fuel
end
