#!/usr/bin/env ruby -w

require "set"

class DeXMAS
  def initialize preamble:, input:
    @size = preamble
    @numbers = input.split(/\s+/).map(&:to_i)
  end

  def weakness
    @numbers.each_cons(@size.succ) do |nums|
      sum = nums.pop
      if nums.combination(2).none?{|pair| pair.sum == sum }
        return sum
      end
    end
  end

  def max_product
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  d =  DeXMAS.new(preamble: 25, input: input)
  puts d.weakness
end
