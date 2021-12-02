#!/usr/bin/env ruby -w

class Submarine
  attr_reader :position, :depth

  def initialize
    @position = 0
    @depth = 0
  end

  def plot_course course
    course.scan(/(\w*) (\d*)/).map do |op, val|
      move op.to_sym, val.to_i
    end
  end

  def move direction, distance
    case direction
    when :forward
      @position += distance
    when :down
      @depth += distance
    when :up
      @depth -= distance
    else
      raise "wat: #{direction}"
    end
  end

  def coord
    @position * depth
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  sub = Submarine.new
  sub.plot_course input
  puts sub.coord
end
