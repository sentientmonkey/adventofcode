require "minitest/autorun"
require "minitest/pride"

require_relative "day12.rb"

class Test < Minitest::Test
  def setup
    @ship = Ship.new
  end

  def test_ship_moves_forward
    @ship.nav "F10"
    assert_equal @ship.position, Pos.new(10, 0)
  end

  def test_ship_moves_north
    @ship.nav "N3"
    assert_equal @ship.position, Pos.new(0, 3)
  end

  def test_ship_rotates_south
    @ship.nav "R90"
    @ship.nav "F11"
    assert_equal @ship.position, Pos.new(0, -11)
  end

  def test_ship_rotates_north
    @ship.nav "L90"
    @ship.nav "F11"
    assert_equal @ship.position, Pos.new(0, 11)
  end

  def test_nav_squence
    input = <<~EOS
    F10
    N3
    F7
    R90
    F11
    EOS

    @ship.sequence input
    assert_equal Pos.new(17,-8), @ship.position
    assert_equal 25, @ship.distance
  end
end
