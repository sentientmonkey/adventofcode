class Day01
  attr_reader :input

  DIGITS = {
    'one' => 1,
    'two' => 2,
    'three' => 3,
    'four' => 4,
    'five' => 5,
    'six' => 6,
    'seven' => 7,
    'eight' => 8,
    'nine' => 9
  }.freeze

  def initialize(input)
    @input = input
  end

  def checksum
    numbers.sum
  end

  def numbers
    input.split("\n").map do |line|
      extract line
    end
  end

  def extract(line)
    xs = line
         .scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/)
         .flatten
         .map { |d| to_number(d) }
    [xs[0], xs[-1]].join.to_i
  end

  def to_number(digit)
    DIGITS.fetch(digit) { digit }.to_s
  end
end

puts Day01.new(ARGF.read).checksum if __FILE__ == $0
