#!/usr/bin/env ruby -w

class Computer
  ADD   = 1
  MULT  = 2 
  STORE = 3
  PRINT = 4
  HALT  = 99

  def self.run stack
    pc = 0
    output = ""
    loop do
      raise "catch fire" if pc >= stack.size
      opcode = stack[pc]
      pc+=1
      case opcode % 100
      when ADD
        arg = stack[pc...(pc+2)]
        p = params opcode, arg, stack
        stack[stack[pc+2]] = p[0] + p[1]
        pc+=3
      when MULT
        arg = stack[pc...(pc+2)]
        p = params opcode, arg, stack
        stack[stack[pc+2]] = p[0] * p[1]
        pc+=3
      when STORE
        arg = stack[pc...(pc+1)]
        p = params opcode, arg, stack
        stack[stack[pc+1]] = p[0]
        pc+=2
      when PRINT
        arg = stack[pc...(pc+1)]
        p = params opcode, arg, stack
        output << p[0].to_s
        pc+=1
      when HALT
        break
      else
        raise "unknown opcode: #{opcode}\n#{stack}\n#{pc}"
      end
    end
    [stack,output]
  end

  def self.instruction pos, stack, pc, param_count
    stack[(pc)...(pc+param_count)]
  end

  def self.params opcode, ins, stack
    ins.each_with_index.map do |param,i|
      div = 10**(i+2)
      if ((opcode / div) % 2) == 1 || i >= 3
        param
      else
        stack[param]
      end
    end
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
  stack,output = Computer.run program
  puts output
end
