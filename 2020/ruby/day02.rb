#!/usr/bin/env ruby -w


class TheLastPass
  def initialize input
    @entries = input.split("\n").map do |line|
      line.match(/(?<min>\d+)-(?<max>\d+) (?<char>[a-z]): (?<password>[a-z]+)/)
    end
  end

  def valid_count
    @entries.select do |entry|
      count = entry[:password].count(entry[:char])
      count <= entry[:max].to_i && count >= entry[:min].to_i
    end.size
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  pass = TheLastPass.new input
  puts pass.valid_count
end
