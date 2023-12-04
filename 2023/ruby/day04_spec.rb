require_relative 'day04'

RSpec.describe Day04 do
  let(:exercise) do
    described_class.new input
  end

  let(:input) do
    <<~INPUT
      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
      Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
      Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
      Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
      Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
      Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    INPUT
  end

  it 'should parse cards' do
    card = exercise.cards.first
    expect(card.number).to eq(1)
    expect(card.winners).to include(
      41, 48, 83, 86, 17
    )
    expect(card.actual).to include(
      83, 86, 6, 31, 17, 9, 48, 53
    )
  end

  it 'should have winning numbers' do
    card = exercise.cards.first
    expect(card.actual_winners).to contain_exactly(
      48, 83, 17, 86
    )
  end

  it 'should score points' do
    expect(exercise.cards.map(&:points)).to eq(
      [8, 2, 2, 1, 0, 0]
    )

    expect(exercise.total_points).to eq(13)
  end

  it 'should find next cards' do
    card = exercise.cards.first
    expect(card.next_cards).to contain_exactly(
      2, 3, 4, 5
    )
    expect(exercise.cards[1].next_cards).to contain_exactly(
      3, 4
    )
  end

  it 'should count cards' do
    expect(exercise.collect_all).to eq(
      {
        1 => 1,
        2 => 2,
        3 => 4,
        4 => 8,
        5 => 14,
        6 => 1
      }
    )
  end
end
