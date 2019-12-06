#!/usr/bin/env ruby -w

class Computer
  ADD   = 1
  MULT  = 2 
  STORE = 3
  PRINT = 4
  JMPT  = 5
  JMPF  = 6
  LESS  = 7
  EQL   = 8
  HALT  = 99

  def self.run stack, initial_input=nil
    pc = 0
    output = []
    input = []
    if initial_input
      input << initial_input
    end
    trace = ENV["TRACE"]
    loop do
      raise "catch fire" if pc >= stack.size
      if trace
        debug "PC", pc
        debug "Stack", stack
        debug "input", input
        debug "output", output
      end
      opcode = stack[pc]
      pc+=1
      case opcode % 100
      when ADD
        arg = stack[pc,2]
        p = params opcode, arg, stack
        stack[stack[pc+2]] = p[0] + p[1]
        pc+=3
      when MULT
        arg = stack[pc,2]
        p = params opcode, arg, stack
        stack[stack[pc+2]] = p[0] * p[1]
        pc+=3
      when EQL
        arg = stack[pc,2]
        p = params opcode, arg, stack
        stack[stack[pc+2]] = p[0] == p[1] ? 1 : 0
        pc+=3
      when LESS
        arg = stack[pc,2]
        p = params opcode, arg, stack
        stack[stack[pc+2]] = p[0] < p[1] ? 1 : 0
        pc+=3
      when JMPF
        arg = stack[pc,2]
        p = params opcode, arg, stack
        if p[0].zero?
          pc = p[1]
        else
          pc+=3
        end
      when STORE
        stack[stack[pc]] = input.shift
        pc+=1
      when PRINT
        arg = stack[pc,1]
        p = params opcode, arg, stack
        output << p[0]
        pc+=1
      when HALT
        break
      else
        debug "PC", pc
        debug "Stack", stack
        raise "unknown opcode: #{opcode}"
      end
    end
    [stack,output]
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

  def self.debug desc, value 
    puts "#{desc}: #{value}"
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
  _,output = Computer.run program, 1
  puts output
end
