require "minitest/autorun"
require "minitest/pride"

require_relative "day12.rb"

class Test < Minitest::Test
  def setup
    @ship = Ship.new
    @waypoint_ship = Ship.new waypoint: Pos.new(10,1)
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

  def test_waypoint_move_forward
    @waypoint_ship.nav "F10"
    assert_equal Pos.new(100, 10), @waypoint_ship.position
  end

  def test_waypoint_move_north
    @waypoint_ship.nav "N3"
    assert_equal Pos.new(10, 4), @waypoint_ship.waypoint
  end

  def test_waypoint_rotate
    @waypoint_ship.nav "N3"
    @waypoint_ship.nav "R90"
    assert_equal Pos.new(4,-10), @waypoint_ship.waypoint
  end

  def test_waypoint_rotate
    @waypoint_ship.nav "N3"
    @waypoint_ship.nav "L90"
    assert_equal Pos.new(-4,10), @waypoint_ship.waypoint
  end

  def test_waypoint_nav_squence
    input = <<~EOS
    F10
    N3
    F7
    R90
    F11
    EOS

    @waypoint_ship.sequence input
    assert_equal Pos.new(214,-72), @waypoint_ship.position
    assert_equal 286, @waypoint_ship.distance
  end

end
