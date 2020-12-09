#!/usr/bin/env ruby -w

require "set"

class DeXMAS
  def initialize preamble:, input:
    numbers = input.split(/\s+/).map(&:to_i)
    @preamble = numbers[0...preamble]
    @remaining = numbers[preamble..-1]
  end

  def weakness
    while sum = @remaining.shift
      a = @preamble.find{ |a| @preamble.member?(sum-a) }
      return sum unless a
      @preamble.delete_at(0)
      @preamble << sum
    end
    nil
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  puts DeXMAS.new(preamble: 25, input: input).weakness
end
