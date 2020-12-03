#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day03.rb"

class TobogganTest < Minitest::Test
  def setup
    input = <<~EOS
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    EOS

    @toboggan = Toboggan.new input
  end

  def test_toboggan_input
    assert_equal 11,  @toboggan.length
    assert_equal ".", @toboggan.pos(0,0)
    assert_equal "#", @toboggan.pos(2,0)
    assert_equal "#", @toboggan.pos(0,1)
    assert_equal "#", @toboggan.pos(10,10)
    assert_equal ".", @toboggan.pos(11,0)
  end

  def test_toboggan_moves
    @toboggan.move(3,1)
    assert_equal ".", @toboggan.check
    @toboggan.move(3,1)
    assert_equal "#", @toboggan.check
  end


  def test_togobban_is_trees
    [false, true, false, true, true, false, true, true, true, true].each do |tree|
      @toboggan.move(3,1) 
      assert_equal tree, @toboggan.tree?
    end
  end

  def test_toboggan_end
    11.times do |i|
      refute @toboggan.end?, "end?: #{i}"
      @toboggan.move(3,1) 
    end
    assert @toboggan.end?
  end

  def test_togobban_trees
    assert_equal 7, @toboggan.tree_count
  end
end
