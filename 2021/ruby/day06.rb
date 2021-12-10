#!/usr/bin/env ruby -w

class LanternFish
  attr_reader :timer

  def initialize timer
    @timer = timer
  end

  def next_day!
    @timer -= 1
    if @timer < 0
      @timer = 6
      return self.class.new 8
    end
  end
end

class LanternFishPopulation
  def initialize(timers)
    @fishes = timers.map {|t| LanternFish.new t }
  end

  def size
    @fishes.size
  end

  def run_days! days
    days.times { next_day! }
  end

  def next_day!
    new_fish = @fishes.map { |fish| fish.next_day! }.compact
    @fishes.concat new_fish
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
end
