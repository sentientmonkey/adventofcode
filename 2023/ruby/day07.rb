CARD_VALUES = { 'A' => 14,
                'K' => 13,
                'Q' => 12,
                'J' => 11,
                'T' => 10 }.freeze

Hand = Data.define(:cards, :bid) do
  def type
    counts = cards.chars.tally.values
    if counts.include?(5)
      7
    elsif counts.include?(4)
      6
    elsif counts.include?(3) && counts.include?(2)
      5
    elsif counts.max == 3
      4
    elsif counts.count { |c| c == 2 } == 2
      3
    elsif counts.include?(2)
      2
    else
      1
    end
  end

  def values
    cards.chars.map do |c|
      CARD_VALUES.fetch(c, c.to_i)
    end
  end

  def <=>(other)
    ta = type
    tb = other.type
    return -1 if ta < tb
    return 1 if ta > tb

    values.zip(other.values) do |(va, vb)|
      return va <=> vb if va != vb
    end

    0
  end
end

class Day07
  attr_reader :hands

  def initialize(input)
    @hands = input.split("\n").map do |line|
      cards, bid = line.split
      Hand.new(cards: cards, bid: bid.to_i)
    end
  end

  def ranked
    hands.sort
  end

  def total_winnings
    hands.sort.each_with_index.map do |hand, i|
      hand.bid * (i + 1)
    end.sum
  end
end

if __FILE__ == $0
  exercise = Day07.new ARGF.read
  puts exercise.total_winnings
end
