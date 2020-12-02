#!/usr/bin/env ruby -w


class TheLastPass
  def initialize input
    @entries = input.split("\n").map do |line|
      line.match(/(?<from>\d+)-(?<to>\d+) (?<char>[a-z]): (?<password>[a-z]+)/)
    end
  end

  def min_max_count
    @entries.select do |entry|
      count = entry[:password].count(entry[:char])
      max = entry[:to].to_i 
      min = entry[:from].to_i 
      count <= max && count >= min
    end.size
  end

  def index_count
    @entries.select do |entry|
      contain = entry[:from].to_i 
      not_contain = entry[:to].to_i 

      [entry[:password][contain-1],
       entry[:password][not_contain-1]]
        .count(entry[:char]) == 1
    end.size
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  pass = TheLastPass.new input
  puts pass.index_count
end
