CARD_VALUES = { 'A' => 14,
                'K' => 13,
                'Q' => 12,
                'J' => 11,
                'T' => 10 }.freeze

HAND_TYPES = %i[
  high_card
  one_pair
  two_pair
  three_of_a_kind
  full_house
  four_of_a_kind
  five_of_a_kind
].each_with_index.to_h

JOKER_VALUES = CARD_VALUES.merge({ 'J' => 1 }).freeze

Hand = Data.define(:cards, :bid) do
  def type
    counts = tally_values
    if counts.include?(5)
      :five_of_a_kind
    elsif counts.include?(4)
      :four_of_a_kind
    elsif counts.include?(3) && counts.include?(2)
      :full_house
    elsif counts.max == 3
      :three_of_a_kind
    elsif counts.count { |c| c == 2 } == 2
      :two_pair
    elsif counts.include?(2)
      :one_pair
    else
      :high_card
    end
  end

  def type_value
    HAND_TYPES[type]
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
    ta = type_value
    tb = other.type_value
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
    return [5] if tally.empty?

    if joker_count
      m = tally.max_by { |_, v| v }.first
      tally.merge!(tally) do |k, v|
        if k == m
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
