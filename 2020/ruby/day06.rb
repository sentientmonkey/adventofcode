#!/usr/bin/env ruby -w

require "set"

def all_yes input
  input.split(/\n{2}/)
    .map{ |answers| group_yes(answers) }
    .sum
end

def tally items
  items.each_with_object(Hash.new(0)) do |a,counts|
    counts[a] = counts[a].succ
  end
end

def group_yes input
  answers = input.split(/\s+/)
  tally(answers.join('').chars)
    .count{ |_,v| v == answers.size }
end

def all_answers input
  input.split(/\n{2}/)
    .map{ |answers| group_answer(answers) }
    .sum
end

def group_answer answers
  Set.new(answers.split(/\s+/).join('').chars).size
end

if __FILE__ == $0
  input = ARGF.read.chomp
  puts all_answers(input)
  puts all_yes(input)
end
