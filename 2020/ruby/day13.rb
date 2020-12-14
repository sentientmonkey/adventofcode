#!/usr/bin/env ruby -w


class Timetable
  attr_reader :start_time, :bus_routes, :all_routes, :start_at

  def initialize input, start_at:0
    first, rest = input.split("\n")
    @start_time = first.to_i
    @all_routes = rest.split(',')
      .map{ |route| route == "x" ? route : route.to_i }
    @bus_routes = @all_routes 
      .reject{ |route| route == "x" }
    @start_at = start_at
  end

  def next_bus
    time = (@start_time..).lazy
      .find{ |time| stops? time }
    [time-start_time, stops?(time)]
  end

  def stops? time
    bus_routes.find{ |route| time%route == 0 }
  end

  def golden_timestamp n:nil
    (start_at..n).lazy
      .each_cons(all_routes.size)
      .find do |times| 
          times.zip(all_routes).all? do |time, route| 
            can_stop? time, route 
          end
      end&.first
  end

  def can_stop? time, route
    (route == "x" || time%route == 0)
  end
end

if __FILE__ == $0
  input = ARGF.read.chomp
  timetable = Timetable.new(input, start_at: 100000000000000)
  puts timetable.next_bus.reduce(&:*)
  puts timetable.golden_timestamp
end
