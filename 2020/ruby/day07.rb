#!/usr/bin/env ruby -w

def hold_shiny input
  rules = input.split("\n")
  results = find_matches(rules)
  search = results.dup
  while !search.empty?
    puts results.inspect
    e = search.shift
    m = find_matches(rules, e)
    results.push(*m)
    search.push(*m)
    search.uniq!
  end
  results.uniq.size
end

def find_matches rules, entry="shiny gold"
  rules.select { |rule|
    rule.match(/contain.*\d+ #{entry}/)
  }.map { |rule| rule.match(/(\w+ \w+) bags contain/)[1] }
end

if __FILE__ == $0
  input = ARGF.read.chomp
  puts hold_shiny(input)
end
