#!/usr/bin/env ruby -w

class Panel
  def self.trace route
    wire_a, wire_b = route.split "\n"
    trace_a = path(wire_a)
    trace_b = path(wire_b)
    filtered = crosses(trace_a,trace_b)
    minimum_distance(filtered)
  end

  def self.path wire
    trace = []

    x = 0
    y = 0

    wire.split(',').each do |move|
      direction = move[0]
      distance = move[1..].to_i

      v = dv direction, distance

      1.upto(distance) do
        x += v[0] / distance
        y += v[1] / distance
        trace.push [x,y]
      end
    end

    trace
  end

  def self.dv direction, distance
    case direction
    when "R"
      [distance,0]
    when "L"
      [-distance,0]
    when "U"
      [0,distance]
    when "D"
      [0,-distance]
    else
      raise "wut"
    end
  end

  def self.crosses a, b
    a & b
  end

  def self.minimum_distance crosses
    crosses.map do |cross|
      a,b = cross
      a.abs + b.abs
    end.min
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  puts Panel.trace input
end
