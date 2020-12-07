#!/usr/bin/env ruby -w

def hold_shiny input
  tree = Hash.new { |h, k| h[k] = [] }
  rules = input.split("\n")
  rules.each do |rule|
    m = rule.match(/(\w+ \w+) bags contain \d+ (\w+ \w+) bags?(?:, \d+ (\w+ \w+) bags?)*\./)
    if m
      tree[m[1]].push(*m[2..])
    end
  end
  puts tree.inspect
  results = []
  search = ["shiny gold"]
  while !search.empty?
    puts search.inspect
    e = search.shift
    matches = tree.select{|_,v| v.include? e }.keys
    results.push(*matches)
    search.push(*matches)
  end
  results.uniq.size
end

if __FILE__ == $0
  input = ARGF.read.chomp
  puts hold_shiny(input)
end
