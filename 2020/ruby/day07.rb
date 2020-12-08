#!/usr/bin/env ruby -w

def hold_shiny input
  rules = input.split("\n")
  results = find_matches(rules)
  search = results.dup
  while !search.empty?
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

def shiny_holds input
  rules = input.split("\n")
  results = find_holds rules
  search = results.dup
  while !search.keys.empty?
    key = search.keys.first
    _, level = search.delete(key)
    m = find_holds(rules, key, level)
    results.merge!(m)
    search.merge!(m)
  end
  puts results.inspect
  results.values.map{ |count,level| count*level }.sum
end

def find_holds rules, entry="shiny gold", level=1
  puts "find_holds #{entry}, #{level}"
  rules.select{ |rule|
    rule.match(/#{entry} bags contain \d+/)
  }.map { |rule| rule.match(/(\d \w+ \w+) bags?(?:, (\d \w+ \w+) bags?)+/)[1..] }
    .flatten.map{ |bag|
     m = bag.match(/(\d+) (\w+ \w+)/)
     [m[2], [m[1].to_i, level.succ]]
  }.to_h
end

if __FILE__ == $0
  input = ARGF.read.chomp
  puts hold_shiny(input)
end
