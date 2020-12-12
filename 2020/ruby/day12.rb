#!/usr/bin/env ruby -w

NORTH = 0 
EAST = 90
SOUTH = 180
WEST = 270

Pos = Struct.new(:x, :y) do
  def +(other)
    Pos.new x+other.x, y+other.y
  end

  def -(other)
    Pos.new x-other.x, y-other.y
  end

  def >>(degrees)
    case degrees
    when 0
      self
    when 360
      self
    when 90
      Pos.new(y,-x)
    when 180
      Pos.new(-x,-y)
    when 270
      Pos.new(-y,x)
    else
      raise "unknown direction #{degrees}"
    end
  end

  def <<(degrees)
    case degrees
    when 0
      self
    when 360
      self
    when 90
      self >> 270
    when 180
      self >> 180
    when 270
      self >> 90
    else
      raise "unknown direction #{degrees}"
    end
  end

  def distance
    x.abs + y.abs
  end
end

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
  attr_reader :position, :direction, :waypoint

  def initialize waypoint: nil
    @position = Pos.new(0,0)
    @direction = Direction.new(90)
    @waypoint = waypoint
  end

  def sequence input, trace = false
    input.split("\n").each do |cmd|
      nav cmd
      if trace
        puts cmd
        puts self
      end
    end
  end

  def to_s
    "pos:#{position.inspect} #{direction.inspect} way:#{waypoint.inspect}"
  end

  def distance
    @position.distance
  end

  def nav command
    action, value = command[0], command[1...].to_i
    if waypoint
      waypoint_nav action, value
    else
      normal_nav action, value
    end
  end

  def waypoint_nav action, value
    case action
    when 'F'
      value.times do
        @position += @waypoint
      end
    when 'N'
      @waypoint += North.dxy(value)
    when 'S'
      @waypoint += South.dxy(value)
    when 'E'
      @waypoint += East.dxy(value)
    when 'W'
      @waypoint += West.dxy(value)
    when 'R'
      @waypoint >>= value
    when 'L'
      @waypoint <<= value
    else
      raise "unknown action: #{action}"
    end
  end

  def normal_nav action, value 
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

  waypoint_ship = Ship.new waypoint: Pos.new(10,1)
  waypoint_ship.sequence input
  puts waypoint_ship.distance
end
