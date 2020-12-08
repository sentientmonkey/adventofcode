#!/usr/bin/env ruby -w

class GameboyDebugger
  attr_reader :patch_pos

  def initialize input
    @input = input
    @patch_pos = 0
  end

  def acc
    @gb.acc
  end

  def run
    reset!
    while @patch_pos <= @input.size
      case getop
      when :jmp
        patch @patch_pos, :nop
      when :nop
        patch @patch_pos, :jmp
      when :acc
        adv_pos
        next
      end
      break if halt?
      adv_pos
    end
  end

  def adv_pos
    @patch_pos = @patch_pos.succ
  end

  def patch pos, op
    reset!
    @gb.stack[pos][0] = op
    @gb.run
  end

  def getop
    @gb.stack[@patch_pos][0]
  end

  def halt?
    @gb.halt?
  end

  def reset!
    @gb = Gameboy.new @input
  end
end

class Gameboy
  attr_reader :stack, :acc, :pos, :pc

  def initialize input, debug=false
    @stack = parse input
    @acc = 0
    @pos = 0
    @exit = 0
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
      if infinite_loop?
        @exit = 1
        break
      end
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

  def halt?
    @exit == 0
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
  input = ARGF.read.chomp
  gbd = GameboyDebugger.new(input)
  gbd.run
  puts gbd.acc
end
