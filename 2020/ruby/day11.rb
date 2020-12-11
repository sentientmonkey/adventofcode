#!/usr/bin/env ruby -w

class GameOfButts
  attr_reader :state

  FLOOR = '.'
  EMPTY = 'L'
  TAKEN = '#'
  NEIGHBORS = [[-1,-1], [-1,0], [-1,1],
               [ 0,-1],         [0, 1],
               [1, -1], [1,0], [1, 1]]
  
  def initialize input
    @state = input.split("\n").map(&:chars)
  end

  def ajacent? i, j, value
    size = @state.size
    NEIGHBORS.count do |di,dj| 
       ii,jj = di+i,dj+j
       ii.between?(0, size-1) && 
         jj.between?(0, size-1) &&
         @state[ii][jj] == value
     end
  end

  def tick
    @state = @state.each_with_index.map do |r,i|
      r.each_with_index.map do |v,j|
        case v
        when FLOOR
          FLOOR
        when EMPTY
          if ajacent?(i, j, TAKEN).zero?
            TAKEN
          else
            EMPTY
          end
        when TAKEN
          if ajacent?(i, j, TAKEN) >= 4
            EMPTY
          else
            TAKEN
          end
        else
          raise "wat #{i}"
        end
      end
    end
  end

  def occupied
    @state.map { |r| r.count{ |s| s == TAKEN } }.sum
  end

  def to_s
    @state.map{|r| r.join '' }.join "\n"
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  game = GameOfButts.new(input)
  prev = nil
  while prev != game.tick
    puts game.to_s
    puts
    prev = game.state
  end
  puts game.occupied
end
