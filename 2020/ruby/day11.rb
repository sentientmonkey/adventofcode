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

  def size
    @state.size
  end

  def ajacent? i, j, value
    NEIGHBORS.count do |di,dj| 
       ii,jj = di+i,dj+j
       ii.between?(0, size-1) && 
         jj.between?(0, size-1) &&
         @state[ii][jj] == value
     end
  end

  def can_see i, j, di, dj
    ii = di+i
    jj = dj+j
    while ii.between?(0,size-1) && jj.between?(0,size-1)
      if @state[ii][jj] == TAKEN
        return 1
      end
      if @state[ii][jj] == EMPTY
        return 0
      end
      ii = di+ii
      jj = dj+jj
    end
    0
  end

  def can_see_count i, j
    NEIGHBORS.map {|di,dj| can_see(i, j, di, dj) }.sum
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

  def new_tick
    @state = @state.each_with_index.map do |r,i|
      r.each_with_index.map do |v,j|
        case v
        when FLOOR
          FLOOR
        when EMPTY
          if can_see_count(i, j).zero?
            TAKEN
          else
            EMPTY
          end
        when TAKEN
          if can_see_count(i, j) >= 5
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

  def run
    prev = nil
    while prev != tick
      puts self.to_s
      puts
      prev = state
    end
  end

  def run_new
    prev = nil
    while prev != new_tick
      puts self.to_s
      puts
      prev = state
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
  game.run_new
  puts game.occupied
end
