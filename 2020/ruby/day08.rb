#!/usr/bin/env ruby -w

class Gameboy
  attr_reader :stack, :acc, :pos, :pc

  def initialize input, debug=false
    @stack = parse input
    @acc = 0
    @pos = 0
    @debug = debug
    @trace = Array.new(@stack.size)
  end

  def parse input
    input.split("\n").map do |line|
      line.match(/(\w{3}) ((?:\+|\-)\d+)/)
      raise "invalid instruction #{line}" unless $~
      [$1.to_sym, $2.to_i]
    end
  end

  def op
    @stack[@pos][0]
  end

  def val
    @stack[@pos][1]
  end

  def run
    while @pos < @stack.size
      break if infinite_loop?
      case op
      when :nop
        trace
        @pos = @pos.succ
      when :acc
        @acc += val
        trace
        @pos = @pos.succ
      when :jmp
        trace
        @pos += val
      else
        raise "Invalid instruction #{ins}"
      end
    end
  end

  def infinite_loop?
    !@trace[@pos].nil?
  end

  def trace
    debug
    @trace[@pos] = @acc
  end

  def debug
    return unless @debug
    sleep 1
    puts "#{op} #{val} | #{acc}"
  end
end

if __FILE__ == $0
  gb = Gameboy.new(ARGF.read.chomp)
  gb.run
  puts gb.acc
end
