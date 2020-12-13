require "minitest/autorun"
require "minitest/pride"

require_relative "day13.rb"

class TestTimetable < Minitest::Test
  def setup
    input = <<~EOS
    939
    7,13,x,x,59,x,31,19
    EOS
    @timetable = Timetable.new input
  end

  def test_timetable
    assert_equal 939, @timetable.start_time
    assert_equal [7,13,59,31,19], @timetable.bus_routes
    assert_equal [5,59], @timetable.next_bus
  end
end
