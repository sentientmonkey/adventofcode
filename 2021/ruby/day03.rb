#!/usr/bin/env ruby -w

class Analyzer
  def initialize(report)
    @measurements = report.split("\n").map(&:chars)
  end

  def processed
    @processed ||= (
      @measurements.transpose.map { |pos|
        pos.tally
      }
    )
  end

  def gamma_rate
    processed.map { |tally|
      tally.max_by{|(_,v)| v }.first 
    }.join.to_i(2)
  end

  def epsilon_rate
    processed.map { |tally|
      tally.min_by{|(_,v)| v }.first 
    }.join.to_i(2)
  end

  def power_consumption
    gamma_rate * epsilon_rate
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  puts Analyzer.new(input).power_consumption
end
