require "minitest/autorun"
require "minitest/pride"

require_relative "day11.rb"

class TestGameOfButts < Minitest::Test

  def assert_tick expected_state, input
    assert_equal expected_state, GameOfButts.new(input).tick
  end

  def assert_output expected_output, input
    g = GameOfButts.new(input)
    g.tick
    assert_equal expected_output, g.to_s
  end

  def test_occupy_seats
    assert_tick [['#', '#'],
                 ['#', '#']], <<~EOS
    LL
    LL
    EOS
  end

  def test_floors_nope
    assert_tick [['.', '.'],
                 ['.', '.']], <<~EOS
    ..
    ..
    EOS
  end

  def test_abandon_ship
    assert_tick [['#', 'L', '#'],
                 ['L', 'L', 'L'],
                 ['#', 'L', '#']], <<~EOS
    ###
    ###
    ###
    EOS
  end

  def test_seats_taken
    assert_tick [['#', 'L', '#'],
                 ['L', 'L', 'L'],
                 ['#', 'L', '#']], <<~EOS
    #L#
    L#L
    #L#
    EOS
  end

  def test_run
    input = <<~EOS
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    EOS

    game = GameOfButts.new input

    round_one = <<~EOS.chomp
    #.##.##.##
    #######.##
    #.#.#..#..
    ####.##.##
    #.##.##.##
    #.#####.##
    ..#.#.....
    ##########
    #.######.#
    #.#####.##
    EOS

    game.tick
    assert_equal round_one, game.to_s

    round_two = <<~EOS.chomp
    #.LL.L#.##
    #LLLLLL.L#
    L.L.L..L..
    #LLL.LL.L#
    #.LL.LL.LL
    #.LLLL#.##
    ..L.L.....
    #LLLLLLLL#
    #.LLLLLL.L
    #.#LLLL.##
    EOS

    game.tick
    assert_equal round_two, game.to_s
  end

  def test_occupied
    input = <<~EOS
    #.#L.L#.##
    #LLL#LL.L#
    L.#.L..#..
    #L##.##.L#
    #.#L.LL.LL
    #.#L#L#.##
    ..L.L.....
    #L#L##L#L#
    #.LLLLLL.L
    #.#L#L#.##
    EOS
    game = GameOfButts.new input
    assert_equal game.occupied, 37
  end
end
