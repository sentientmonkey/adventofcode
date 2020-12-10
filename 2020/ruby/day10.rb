#!/usr/bin/env ruby -w

class JoltageAdapter
  def initialize input
    @ratings = input.split(/\s+/).map(&:to_i)
  end

  def rating
    @ratings.max + 3
  end

  def adapters
    [0].concat(@ratings.sort, [rating])
  end

  def tally
    diffs.each_with_object(Hash.new(0)) do |a,counts|
      counts[a] = counts[a].succ
    end
  end

  def diffs
   adapters.each_cons(2).to_a.map { |a,b| b-a }
  end

  def product
    tally.values_at(1, 3).reduce(&:*)
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  puts JoltageAdapter.new(input).product
end
