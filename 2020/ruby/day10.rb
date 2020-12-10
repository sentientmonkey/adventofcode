#!/usr/bin/env ruby -w

def fact(n); n == 0 ? 1 : n * fact(n-1); end

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

  def arrangments
    diffs.slice_when{ |a,b| a != b }
      .select{ |xs| xs.first == 1 }
      .map{ |xs| 2**(xs.size-1) }
      .reduce(&:*)
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  j = JoltageAdapter.new(input)
  puts j.product
  puts j.arrangments
end
