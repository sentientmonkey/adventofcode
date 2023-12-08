CARD_VALUES = { 'A' => 14,
                'K' => 13,
                'Q' => 12,
                'J' => 11,
                'T' => 10 }.freeze

JOKER_VALUES = CARD_VALUES.merge({ 'J' => 1 }).freeze

Hand = Data.define(:cards, :bid) do
  def type
    counts = tally_values
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
      card_value(c)
    end
  end

  def tally_values
    cards.chars.tally.values
  end

  def card_value(c)
    CARD_VALUES.fetch(c, c.to_i)
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

class JokerHand < Hand
  def card_value(c)
    JOKER_VALUES.fetch(c, c.to_i)
  end

  def tally_values
    tally = cards.chars.tally
    joker_count = tally.delete('J')
    if joker_count
      m = tally.values.max
      tally.merge!(tally) do |_, v|
        if v == m
          joker_count + v
        else
          v
        end
      end
    end
    tally.values
  end
end

class Day07
  attr_reader :hands

  def initialize(input, jokers: false)
    hand_class = jokers ? JokerHand : Hand
    @hands = input.split("\n").map do |line|
      cards, bid = line.split
      hand_class.new(cards: cards, bid: bid.to_i)
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
  input = ARGF.read
  exercise = Day07.new input
  puts exercise.total_winnings

  exercise = Day07.new input, jokers: true
  puts exercise.total_winnings
end
