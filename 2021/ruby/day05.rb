#!/usr/bin/env ruby -w

class VentMapper
  def initialize input
    @map = Hash.new { 0 }
    input.split("\n").each do |line|
      m = line.match(/(\d+),(\d+) -> (\d+),(\d+)/)
      if m
        x1,y1,x2,y2 = m.captures.map(&:to_i)
        if y1 == y2
          xmin, xmax = [x1,x2].sort
          (xmin..xmax).each do |x|
            @map[[x,y1]] += 1
          end
        elsif x1 == x2
          ymin, ymax = [y1,y2].sort
          (ymin..ymax).each do |y|
            @map[[x1,y]] += 1
          end
        end
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
end
