#!/usr/bin/env ruby -w

def seat_max input
  input.split(/\s+/)
    .map { |i| seat i }
    .max
end

def seat input
  r = row input[0,7]
  c = col input[7,3]
  r*8 + c
end

def row input, from=0, to=127
  search input, 'F', 'B', 0, 127
end

def col input
  search input, 'L', 'R', 0, 7
end

def search input, up, down, from, to
  if from == to
    return from
  end

  raise "input empty" if input.empty?

  mid = ((to-from)/2.0)
  first = input[0,1]
  rest = input[1..]
  case first
  when up
    search rest, up, down, from, from+mid.floor
  when down
    search rest, up, down, from+mid.ceil, to
  else
    raise "#{first} not valid"
  end
end


if __FILE__ == $0
  input = ARGF.read.chomp
  puts seat_max(input)
end
