#!/usr/bin/env ruby -w


class Timetable
  attr_reader :start_time, :bus_routes

  def initialize input
    first, rest = input.split("\n")
    @start_time = first.to_i
    @bus_routes = rest.split(',')
      .reject{ |route| route == "x" }
      .map(&:to_i)
  end

  def next_bus
    time = (@start_time..).lazy
      .find{ |time| stops? time }
    [time-start_time, stops?(time)]
  end

  def stops? time
    bus_routes.find{ |route| time%route == 0 }
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  timetable = Timetable.new(input)
  puts timetable.next_bus.reduce(&:*)
end
