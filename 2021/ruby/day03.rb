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

  def filter_measurements(&blk)
    canidates = @measurements.dup
    i = 0
    while canidates.size > 1 do
      pos = canidates.transpose
      t = pos[i].tally
      d = if blk.call(t)
        "1"
      else
        "0"
      end
      canidates.reject!{|n| n[i] != d}
      i += 1
    end
    canidates.first.join('').to_i(2)
  end

  def oxygen_generator_rating
    filter_measurements{|t| t["1"] >= t["0"] }
  end

  def co2_scrubber_rating
    filter_measurements{|t| t["1"] < t["0"] }
  end

  def life_support_rating
    oxygen_generator_rating * co2_scrubber_rating
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  analyzer = Analyzer.new(input)
  puts analyzer.power_consumption
  puts analyzer.life_support_rating
end
