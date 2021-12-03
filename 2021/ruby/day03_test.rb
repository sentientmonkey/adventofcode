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
    assert_equal 9, analyzer.epsilon_rate
    assert_equal 198, analyzer.power_consumption
  end
end
