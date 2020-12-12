#!/usr/bin/env ruby -w

Pos = Struct.new(:x, :y) do
  def +(other)
    Pos.new x+other.x, y+other.y
  end

  def distance
    x.abs + y.abs
  end
end

NORTH = 0 
EAST = 90
SOUTH = 180
WEST = 270

Direction = Struct.new(:degrees) do
  def dxy(value)
    case degrees
    when NORTH
      Pos.new(0,value)
    when EAST
      Pos.new(value, 0)
    when SOUTH
      Pos.new(0, -value)
    when WEST
      Pos.new(-value, 0)
    else
      raise "unknown direction #{degrees}"
    end
  end

  def +(value)
    Direction.new((self.degrees + value) % 360)
  end

  def -(value)
    Direction.new((self.degrees - value) % 360)
  end
end

North = Direction.new(NORTH)
East = Direction.new(EAST)
South = Direction.new(SOUTH)
West = Direction.new(WEST)

class Ship
  attr_reader :position, :direction

  def initialize
    @position = Pos.new(0,0)
    @direction = Direction.new(90)
  end

  def sequence input
    input.split("\n").each do |cmd|
      nav cmd
    end
  end

  def distance
    @position.distance
  end

  def nav command 
    action, value = command[0], command[1...].to_i
    case action
    when 'F'
      @position += @direction.dxy(value)
    when 'N'
      @position += North.dxy(value)
    when 'S'
      @position += South.dxy(value)
    when 'E'
      @position += East.dxy(value)
    when 'W'
      @position += West.dxy(value)
    when 'R'
      @direction += value
    when 'L'
      @direction -= value
    else
      raise "unknown action: #{action}"
    end
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  ship = Ship.new
  ship.sequence input
  puts ship.distance
end
