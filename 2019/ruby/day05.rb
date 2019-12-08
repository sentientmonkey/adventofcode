#!/usr/bin/env ruby -w

ADD   = 1
MULT  = 2 
WRITE = 3
READ  = 4
JMPT  = 5
JMPF  = 6
LESS  = 7
EQL   = 8
HALT  = 99

class State
  attr_accessor :mem, :pc, :input, :output

  def initialize mem, initial_input=nil
    @mem = mem
    @pc = 0
    @input = []
    if initial_input
      @input << initial_input
    end
    @output = []
  end

  def [](loc)
    @mem[loc]
  end

  def []=(loc, val)
    @mem[loc] = val
  end

  def past_memory?
    @pc >= @mem.size
  end

  def advance steps=1
    @pc += steps
  end

  def jump loc
    @pc = loc
  end

  def next 
    opcode = @mem[@pc]
    num_args = arg_count opcode
    r = params opcode, @mem[@pc+1,num_args]
    [opcode] + r
  end

  def fetch_input
    @input.shift
  end

  def write_output value
    @output << value
  end

  private

  def params opcode, ins
    ins.each_with_index.map do |param,i|
      div = 10**(i+2)
      if ((opcode / div) % 2) == 1 || i >= 3
        param
      else
        @mem[param]
      end
    end
  end

  def arg_count opcode
    case opcode % 100
    when ADD, MULT, EQL, LESS then 3
    when JMPT, JMPF then 2
    when READ, WRITE, LESS then 1
    when HALT then 1
    else raise "unknown opcode #{opcode}"
    end
  end
end

class Computer
  def self.run stack, initial_input=nil
    state = State.new stack, initial_input
    trace = ENV["TRACE"]
    loop do
      raise "catch fire" if state.past_memory? 
      if trace
        puts state.inspect
      end
      p = state.next
      opcode = p.first
      state.advance
      case opcode % 100
      when ADD
        puts p.inspect
        puts p[3]
        state[state[state.pc+2]] = p[1] + p[2]
      when MULT
        state[state[state.pc+2]] = p[1] * p[2]
      when EQL
        state[state[state.pc+2]] = p[1] == p[2] ? 1 : 0
      when LESS
        state[state[state.pc+2]] = p[1] < p[2] ? 1 : 0
      when JMPF
        if p[1].zero?
          state.jump p[2]
          next
        end
      when JMPT
        if !p[1].zero?
          state.jump p[2]
          next
        end
      when WRITE
        state[state[state.pc]] = state.fetch_input
      when READ
        state.write_output p[1]
      when HALT
        break
      else
        puts state.inspect
        raise "unknown opcode: #{opcode}"
      end
      state.advance p.size-1
    end
    [state.mem,state.output]
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

  program = Computer.compile input
  _,output = Computer.run program, 5
  puts output
end
