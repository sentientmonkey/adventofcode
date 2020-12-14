#!/usr/bin/env ruby -w

class Port
  attr_accessor :mask
  attr_reader :v2

  def initialize init = nil, v2:false
    @mem = Array.new(36, 0)
    @v2 = v2
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
      if md && md[:mask]
        [:mask, md[:mask]]
      elsif md && md[:address] && md[:value]
        [:set, md[:address].to_i, md[:value].to_i]
      else
        raise "parse error: #{line}"
      end
    end
  end

  def checksum
    @mem.compact.sum
  end

  def amask(addr)
    addresses = [[]]
    zipc(mask, to_bin(addr)).each { |bm, v|
      case bm
      when '0'
        addresses.each {|a| a.push(v) }
      when '1'
        addresses.each {|a| a.push('1') }
      when 'X'
        z = addresses.map{ |a| a.dup }
        addresses.each {|a| a.push('0') }
        z.each {|a| a.push('1') }
        addresses = addresses.concat(z)
      else
        raise "wat"
      end
    }
    addresses.map{ |a| a.join('').to_i(2) }.sort
  end

  def []=(addr,value)
    if v2
      amask(addr).each do |a|
        @mem[a] = value 
      end
    else
      @mem[addr] = bmask(value)
    end
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
  puts Port.new(input, v2: true).checksum
end
