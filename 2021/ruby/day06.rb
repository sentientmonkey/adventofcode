#!/usr/bin/env ruby -w

class LanternFish
  attr_reader :timer, :count

  def initialize timer, count: 1
    @timer = timer
    @count = count
  end

  def next_day!
    @timer -= 1
    if @timer < 0
      @timer = 6
      return self.class.new 8, count: @count
    end
  end

  def inspect
    "#<Fish timer:#{timer} count:#{count}>"
  end
end

class LanternFishPopulation
  def initialize(timers)
    @fishes = timers.map {|t| LanternFish.new t }
    compact!
  end

  def size
    @fishes.sum(&:count)
  end

  def run_days! days
    days.times { next_day! }
  end

  def next_day!
    new_fish = @fishes.map do |fish|
      fish.next_day!
    end.compact
    @fishes.concat new_fish
    compact!
  end

  def compact!
    @fishes = @fishes.group_by(&:timer).map do |timer,gen|
      LanternFish.new timer, count: gen.sum(&:count)
    end
  end

  def timers
    @fishes.map(&:timer)
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp.split(",").map(&:to_i)
  population = LanternFishPopulation.new input
  population.run_days! 80
  puts population.size
  population = LanternFishPopulation.new input
  population.run_days! 256
  puts population.size
end
