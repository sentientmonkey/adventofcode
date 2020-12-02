#!/usr/bin/env ruby -w

class ExpenseReport
  def initialize input
    @numbers = input.split(/\s+/).map(&:to_i)
  end

  def product size
    @numbers.combination(size)
      .find { |pair| pair.sum == 2020 }
      .flatten
      .reduce(1, :*)
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  report = ExpenseReport.new input
  puts report.product(3)
end
