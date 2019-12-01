#!/usr/bin/env ruby -w

class RocketCalc
  def self.fuel mass
    (mass / 3) - 2
  end

  def self.fuel_sums mass
    sums = []
    loop do
      mass = fuel mass
      break if mass < 0
      sums << mass
    end
    sums
  end

  def self.fuel_extra mass
    fuel_sums(mass).sum
  end

  def self.total_fuel masses
    masses
      .map{|m| fuel(m) }
      .sum
  end

  def self.total_fuel_extra masses
    masses
      .map{|m| fuel_extra(m) }
      .sum
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  masses = input.split(/\s+/).map(&:to_i)
  puts RocketCalc.total_fuel masses
  puts RocketCalc.total_fuel_extra masses
end
