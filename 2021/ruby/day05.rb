#!/usr/bin/env ruby -w

class VentMapper
  def initialize input, diagnals: false
    @map = Hash.new { 0 }
    input.split("\n").each do |line|
      m = line.match(/(\d+),(\d+) -> (\d+),(\d+)/)
      if m
        points = m.captures.map(&:to_i)
        if diagnals
          add_diagnals points
        else
          add points
        end
      end
    end
  end

  def delta(points)
    x1,y1,x2,y2 = points
    if y1 == y2
      if x1 > x2
        [-1,0]
      else
        [1,0]
      end
    elsif x1 == x2
      if y1 > y2
        [0,-1]
      else
        [0,1]
      end
    elsif x1 > x2
      if y1 > y2
        [-1,-1]
      else
        [-1,1]
      end
    else
      if y1 > y2
        [1,-1]
      else
        [1,1]
      end
    end
  end

  def add_diagnals(points)
    x,y,x2,y2 = points
    dx, dy = delta(points)
    mark x, y
    loop do
      x += dx
      y += dy
      mark x, y
      break unless x != x2 || y != y2
    end
  end

  def mark(x,y)
    @map[[x,y]] += 1
  end

  def add(points)
    x1,y1,x2,y2 = points
    if y1 == y2
      xmin, xmax = [x1,x2].sort
      (xmin..xmax).each do |x|
        mark x, y1
      end
    elsif x1 == x2
      ymin, ymax = [y1,y2].sort
      (ymin..ymax).each do |y|
        mark x1, y
      end
    end
  end

  def contains? x, y
    @map.include? [x,y]
  end

  def vents x, y
    @map[[x,y]]
  end

  def overlaps
    @map.values.count{|value| value > 1 }
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  puts VentMapper.new(input).overlaps
  puts VentMapper.new(input, diagnals: true).overlaps
end
