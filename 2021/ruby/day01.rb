#!/usr/bin/env ruby -w

class Sonar
  def initialize(*measurements)
    @measurements = measurements
  end

  def increased
    @measurements.each_cons(2).count { |(a,b)| b > a }
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp.split.map(&:to_i)
  puts Sonar.new(*input).increased
end
