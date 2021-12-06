#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day03.rb"

class AnalyzerTest < Minitest::Test
  def test_analyze
    analyzer = Analyzer.new <<~EOS
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    EOS

    assert_equal 22, analyzer.gamma_rate
    assert_equal 198, analyzer.power_consumption

    assert_equal 23, analyzer.oxygen_generator_rating
    assert_equal 10, analyzer.co2_scrubber_rating
    assert_equal 230, analyzer.life_support_rating
  end
end
