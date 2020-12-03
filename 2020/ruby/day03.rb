#!/usr/bin/env ruby -w

class Toboggan
  attr_reader :length

  def initialize input
    @rows = input.split(/\s+/)
    @length = @rows.size
    @x = 0
    @y = 0
  end

  def pos x, y
    modx = x % @rows[y].size
    @rows[y][modx]
  end

  def move dx, dy
    @x += dx
    @y += dy
  end

  def check
    pos @x, @y
  end

  def tree?
    check == "#"
  end

  def end?
    @y >= length
  end

  def tree_count
    count = 0
    marks = []
    move 3, 1
    until end?
      if tree?
        marks << "X"
        count += 1
      else
        marks << "O"
      end
      move 3, 1
    end
    count
  end

  def to_s
    @rows.join "\n"
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  toboggan = Toboggan.new input
  puts toboggan.tree_count
end
