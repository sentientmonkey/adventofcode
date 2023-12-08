class Day06
  attr_reader :times, :distances

  def initialize(input)
    input.split("\n").each do |line|
      numbers = line.scan(/\d+/).map(&:to_i)
      case line
      when /Time:/
        @times = numbers
      when /Distance:/
        @distances = numbers
      end
    end
  end

  def races
    times.zip(distances).map do |time, record|
      0.upto(time).select do |speed|
        distance = time - speed
        speed * distance > record
      end
    end
  end

  def ways_to_win
    races.map(&:size)
  end

  def win_product
    ways_to_win.inject(1, :*)
  end
end

if __FILE__ == $0
  exercise = Day06.new ARGF.read
  puts exercise.win_product
end
