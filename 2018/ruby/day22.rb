#!/usr/bin/env ruby -w

if __FILE__ == $0
  class Point
    attr_reader :x, :y
    def initialize x:, y:
      @x = x
      @y = y
    end

    def - rhs
      self.new x: x-rhs.x, y: y-rhs.y
    end
  end

  class Cave
    def initialize depth:, target:
      @depth = depth
      @target = target
    end

    def geological_index point
      case [point.x, point.y]
      when [0,0]
        0
      when [1,0]
        16807
      end
    end

    def erosion_index point
      index = geological_index point
      index + 510
    end

    def type point
      index = erosion_index point
      case index % 3
      when 0
        :rocky
      end
    end
  end

  if ARGV.empty?
    require "minitest/autorun"
    require "minitest/pride"

    class CaveTest < Minitest::Test
      def setup
        @target = Point.new x: 10, y: 10
        @cave = Cave.new depth: 510, target: @target
      end

      def test_origin
        point = Point.new x: 0, y: 0
        assert_equal 0, @cave.geological_index(point)
        assert_equal 510, @cave.erosion_index(point)
        assert_equal :rocky, @cave.type(point)
      end

      def test_wet
        point = Point.new x: 1, y: 0
        assert_equal 16807, @cave.geological_index(point)
        assert_equal 17317, @cave.erosion_index(point)
        assert_equal :wet, @cave.type(point)
      end
    end
  else
    puts "not yet"
  end
end
