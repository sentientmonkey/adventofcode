#!/usr/bin/env ruby -w

class Sonar
  def initialize(*measurements)
    @measurements = measurements
  end

  def increased
    count_increased @measurements
  end

  def window_sums
    @measurements.each_cons(3).map { |nums| nums.sum }
  end

  def windows_increased
    count_increased window_sums
  end

  def count_increased(a)
    a.each_cons(2).count { |(a,b)| b > a }
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp.split.map(&:to_i)
  puts Sonar.new(*input).increased
  puts Sonar.new(*input).windows_increased
end
