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

  def test_find_golden_time
    assert_equal [7,13,'x','x',59,'x',31,19], @timetable.all_routes
    assert_equal 1068781, @timetable.golden_timestamp
  end

  def test_fime_golden_times
    timetable = Timetable.new "0\n17,x,13,19"
    assert_equal 3417, timetable.golden_timestamp

    timetable = Timetable.new "0\n67,7,59,61"
    assert_equal 754018, timetable.golden_timestamp

    timetable = Timetable.new "0\n67,x,7,59,61"
    assert_equal 779210, timetable.golden_timestamp

    timetable = Timetable.new "0\n67,7,x,59,61"
    assert_equal 1261476, timetable.golden_timestamp

  end

  def test_too_slow
    timetable = Timetable.new "0\n1789,37,47,1889", start_at:1200000000
    assert_equal 1202161486, timetable.golden_timestamp
  end
end
