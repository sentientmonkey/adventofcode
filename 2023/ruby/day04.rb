Card = Data.define(:number, :winners, :actual) do
  def actual_winners
    winners.intersection actual
  end

  def points
    win_count = actual_winners.size
    if win_count > 2
      win_count * 2
    else
      win_count
    end
  end
end

class Day04
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def cards
    input.split("\n").map do |line|
      match = line.match(/Card +(\d+): ([\d ]+)\|([\d ]+)/)

      Card.new(
        match[1].to_i,
        match[2].squeeze.split.map(&:to_i),
        match[3].squeeze.split.map(&:to_i)
      )
    end
  end

  def total_points
    cards.map(&:points).sum
  end
end

if __FILE__ == $0
  d = Day04.new(ARGF.read)
  puts d.total_points
end
