#!/usr/bin/env ruby -w


class TheLastPass
  def initialize input
    @entries = input.split("\n").map do |line|
      line.match(/(?<from>\d+)-(?<to>\d+) (?<char>[a-z]): (?<password>[a-z]+)/)
    end
  end

  def min_max_count
    @entries.select do |entry|
      password, char, to, from = entry.values_at(
        :password, :char, :to, :from
      )
      count = password.count(char)
      count <= to.to_i && count >= from.to_i
    end.size
  end

  def index_count
    @entries.select do |entry|
      password, char, to, from = entry.values_at(
        :password, :char, :to, :from
      )
      contain = from.to_i - 1
      not_contain = to.to_i - 1

      [password[contain],
       password[not_contain]]
        .count(char) == 1
    end.size
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  pass = TheLastPass.new input
  puts pass.index_count
end
