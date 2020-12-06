#!/usr/bin/env ruby -w

require "set"

def all_answers input
  input.split(/\n{2}/)
    .map{ |answers| group_answer(answers) }
    .sum
end

def group_answer answers
  set = Set.new answers.split(/\s+/).join('').chars
  set.size
end

if __FILE__ == $0
  input = ARGF.read.chomp
  puts all_answers(input)
end
