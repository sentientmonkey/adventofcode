class Day01
  attr_reader :input

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
    d = line.scan(/\d/)
    [d[0], d[-1]].join.to_i
  end
end

puts Day01.new(ARGF.read).checksum if __FILE__ == $0
