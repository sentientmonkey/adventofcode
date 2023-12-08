require_relative 'day07'

RSpec.describe Day07 do
  let(:input) do
    <<~INPUT
      32T3K 765
      T55J5 684
      KK677 28
      KTJJT 220
      QQQJA 483
    INPUT
  end

  context 'normal hand' do
    let(:exercise) do
      described_class.new input
    end

    def hand_type(cards)
      Hand.new(cards: cards, bid: 0).type
    end

    def hand_values(cards)
      Hand.new(cards: cards, bid: 0).values
    end

    it 'should parse hands' do
      hand = exercise.hands.first
      expect(hand.cards).to eq('32T3K')
      expect(hand.bid).to eq(765)
    end

    it 'should return type for hands' do
      expect(hand_type('32T3K')).to eq(2)
      expect(hand_type('KTJJT')).to eq(3)
      expect(hand_type('KK677')).to eq(3)
      expect(hand_type('T55J5')).to eq(4)
      expect(hand_type('QQQJA')).to eq(4)

      expect(hand_type('AAAAA')).to eq(7)
      expect(hand_type('AA8AA')).to eq(6)
      expect(hand_type('23332')).to eq(5)
      expect(hand_type('TTT98')).to eq(4)
      expect(hand_type('23432')).to eq(3)
      expect(hand_type('A23A4')).to eq(2)
      expect(hand_type('23456')).to eq(1)
    end

    it 'should return values' do
      expect(hand_values('32T3K')).to eq([3, 2, 10, 3, 13])
    end

    it 'should rank hands' do
      expect(exercise.ranked.map(&:cards)).to eq(
        %w[32T3K KTJJT KK677 T55J5 QQQJA]
      )
    end

    it 'should return winnings' do
      expect(exercise.total_winnings).to eq(6440)
    end
  end

  context 'joker hands' do
    let(:exercise) do
      described_class.new input, jokers: true
    end

    def hand_type(cards)
      JokerHand.new(cards: cards, bid: 0).type
    end

    def hand_values(cards)
      JokerHand.new(cards: cards, bid: 0).values
    end

    it 'should return type for hands' do
      expect(hand_type('32T3K')).to eq(2)
      expect(hand_type('KTJJT')).to eq(6)
      expect(hand_type('KK677')).to eq(3)
      expect(hand_type('T55J5')).to eq(6)
      expect(hand_type('QQQJA')).to eq(6)

      expect(hand_type('AAAAA')).to eq(7)
      expect(hand_type('AA8AA')).to eq(6)
      expect(hand_type('23332')).to eq(5)
      expect(hand_type('TTT98')).to eq(4)
      expect(hand_type('23432')).to eq(3)
      expect(hand_type('A23A4')).to eq(2)
      expect(hand_type('23456')).to eq(1)
    end

    it 'should return values' do
      expect(hand_values('QJJQ2')).to eq([12, 1, 1, 12, 2])
    end

    it 'should rank hands' do
      expect(exercise.ranked.map(&:cards)).to eq(
        %w[32T3K KK677 T55J5 QQQJA KTJJT]
      )
    end

    it 'should return winnings' do
      expect(exercise.total_winnings).to eq(5905)
    end
  end
end
