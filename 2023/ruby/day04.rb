Card = Struct.new(:number, :winners, :actual) do
  def actual_winners
    actual.select do |n|
      winners.include?(n)
    end
  end

  def next_cards
    @next_cards ||= begin
      win_count = actual_winners.size
      win_count.times.map do |i|
        number.succ + i
      end
    end
  end

  def points
    win_count = actual_winners.size
    if win_count > 1
      2**(win_count - 1)
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
    @cards ||= input.split("\n").map do |line|
      match = line.match(/Card +(\d+): ([\d ]+)\|([\d ]+)/)

      Card.new(
        match[1].to_i,
        match[2].split.map(&:to_i),
        match[3].split.map(&:to_i)
      )
    end
  end

  def total_points
    cards.map(&:points).sum
  end

  def collect_all
    visited = {}
    visited.default = 0
    queue = []
    queue << cards.first
    until queue.empty?
      card = queue.shift
      visited[card.number] = visited[card.number] + 1
      next if card.next_cards.empty?

      pp card
      pp card.next_cards

      card.next_cards.each do |num|
        queue << cards.find { |c| (c.number % num).zero? }
      end
    end
    visited
  end
end

if __FILE__ == $0
  d = Day04.new(ARGF.read)
  puts d.total_points
end
