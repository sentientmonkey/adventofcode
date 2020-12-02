#!/usr/bin/env ruby -w

class ExpenseReport
  def initialize input
    @numbers = input.split(/\s+/).map(&:to_i)
  end

  def product
    @numbers.combination(2)
      .find { |pair| pair[0] + pair[1] == 2020 }
      .flatten
      .reduce(1, :*)
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  report = ExpenseReport.new input
  puts report.product
end
