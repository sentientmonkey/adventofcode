#!/usr/bin/env ruby -w

class Computer
  ADD  = 1
  MULT = 2 
  HALT = 99

  def self.run stack
    pc = 0
    loop do
      case opcode = stack[pc]
      when ADD
        loc1, loc2, loc3 = instruction stack, pc
        stack[loc3] = stack[loc1] + stack[loc2]
        pc+=3
      when MULT
        loc1, loc2, loc3 = instruction stack, pc
        stack[loc3] = stack[loc1] * stack[loc2]
        pc+=3
      when HALT
        break
      else
        raise "unknown opcode: #{opcode}"
      end
      pc+=1
    end
    stack
  end

  def self.instruction stack, pc
    stack[(pc+1)...(pc+4)]
  end

  def self.compile program
    program
      .split(',')
      .map(&:to_i)
  end

  def self.alter_program program, noun, verb
    altered = program.dup
    altered[1] = noun
    altered[2] = verb
    altered
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  program = Computer.compile input
  altered = Computer.alter_program program, 12, 2
  stack = Computer.run altered
  puts stack[0]


  0.upto(99).each do |noun|
    0.upto(99).each do |verb|
      altered = Computer.alter_program program, noun, verb
      stack = Computer.run altered
      if stack[0] == 19690720
        result = 100 * noun + verb
        puts result
        exit 0
      end
    end
  end

  puts "no result found"
end
