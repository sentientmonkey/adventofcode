class Day06
  attr_reader :times, :distances

  def initialize(input, kerning: false)
    input.split("\n").each do |line|
      numbers = if kerning
                  [line.scan(/\d+/).join.to_i]
                else
                  line.scan(/\d+/).map(&:to_i)
                end
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
  input = ARGF.read
  exercise = Day06.new input
  puts exercise.win_product

  exercise = Day06.new input, kerning: true
  puts exercise.win_product
end
