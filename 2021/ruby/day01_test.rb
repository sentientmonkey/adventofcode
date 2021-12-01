#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day01.rb"


class SonarTest < Minitest::Test

  def test_sonar_increase_count
    sonar = Sonar.new 199, 200
    assert_equal 1, sonar.increased

    sonar = Sonar.new 199, 200, 188, 201
    assert_equal 2, sonar.increased

    sonar = Sonar.new 199, 200, 208, 210, 200, 207, 240, 269, 260, 263
    assert_equal 7, sonar.increased
  end
end
