#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day04.rb"

class SquidBingoTest < Minitest::Test
  INPUT = <<~EOS
     7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
     8  2 23  4 24
    21  9 14 16  7
     6 10  3 18  5
     1 12 20 15 19

     3 15  0  2 22
     9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
     2  0 12  3  7
  EOS

  def test_read_numbers
    bingo = SquidBingo.new(INPUT)
    assert_equal [7,4,9,5,11], bingo.numbers.take(5)
  end

  def test_read_cards
    bingo = SquidBingo.new(INPUT)
    assert_equal [[22,13, 17, 11, 0],
                  [8, 2, 23, 4, 24],
                  [21, 9, 14, 16, 7],
                  [6, 10, 3, 18, 5],
                  [1, 12, 20, 15, 19]], bingo.cards.first
  end

  def test_draw_numbers
    bingo = SquidBingo.new(INPUT)
    assert_equal [[false, false, false, false, false],
                  [false, false, false, false, false],
                  [false, false, false, false, false],
                  [false, false, false, false, false],
                  [false, false, false, false, false]], bingo.marked.first

    5.times { bingo.draw }

    assert_equal [[false, false, false, true, false],
                  [false, false, false, true, false],
                  [false, true, false, false, true],
                  [false, false, false, false, true],
                  [false, false, false, false, false]], bingo.marked.first
  end

  def test_plays_for_win
    bingo = SquidBingo.new(INPUT)
    bingo.play
    assert_equal 3, bingo.winning_card
  end

  def test_calculates_score
    bingo = SquidBingo.new(INPUT)
    bingo.play
    assert_equal 4512, bingo.score
  end
end
