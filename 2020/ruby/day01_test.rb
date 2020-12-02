#!/usr/bin/env ruby -w

require "minitest/autorun"
require "minitest/pride"

require_relative "day01.rb"


class ExpenseReportTest < Minitest::Test
  def test_find_sum_two
    input = <<~EOS.chomp
      1721
      979
      366
      299
      675
      1456
    EOS
    report = ExpenseReport.new input

    assert_equal 514579, report.product(2)
  end

  def test_find_sum_three
    input = <<~EOS.chomp
      1721
      979
      366
      299
      675
      1456
    EOS
    report = ExpenseReport.new input

    assert_equal 241861950, report.product(3)
  end

end
