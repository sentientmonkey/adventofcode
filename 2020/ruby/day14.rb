#!/usr/bin/env ruby -w

class Port
  attr_accessor :mask

  def initialize init = nil
    @mem = Array.new(36, 0)
    run(init) if init
  end

  def run init
    ast = parse init
    ast.each do |op,a,b|
      case op
      when :mask
        self.mask = a
      when :set
        self[a] = b
      else
        raise "invalid instruction: #{op} #{a} #{b}"
      end
    end
  end

  def parse prog
    prog.split("\n").map do |line|
      md = line.match(/^(mask = (?<mask>[X01]{36}))|(mem\[(?<address>\d+)\] = (?<value>\d+))$/)
      if md[:mask]
        [:mask, md[:mask]]
      elsif md[:address] && md[:value]
        [:set, md[:address].to_i, md[:value].to_i]
      else
        raise "parse error: #{line}"
      end
    end
  end

  def checksum
    @mem.compact.sum
  end

  def []=(addr,value)
    @mem[addr] = bmask(value)
  end

  def [](addr)
    @mem[addr]
  end

  def bmask value
    zipc(mask, to_bin(value)).map { |bm, v|
      bm == 'X' ? v : bm
    }.join('').to_i(2)
  end

  def zipc a, b
    a.chars.zip b.chars
  end

  def to_bin value
    "%036b" % value
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  puts Port.new(input).checksum
end
