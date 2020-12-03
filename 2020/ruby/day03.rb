#!/usr/bin/env ruby -w

class Toboggan
  attr_reader :length

  def initialize input
    @rows = input.split(/\s+/)
    reset
  end

  def reset
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

  def tree_count dx=3, dy=1
    reset
    count = 0
    marks = []
    move dx, dy
    until end?
      if tree?
        marks << "X"
        count += 1
      else
        marks << "O"
      end
      move dx, dy
    end
    count
  end

  def path_product
    [[1,1], [3,1], [5,1], [7,1], [1,2]]
      .map{ |pair| tree_count(pair[0], pair[1]) }
      .reduce(:*)
  end

  def to_s
    @rows.join "\n"
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  toboggan = Toboggan.new input
  puts toboggan.path_product
end
