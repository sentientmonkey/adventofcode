require_relative 'day02'

RSpec.describe Day02 do
  let(:exercise) do
    described_class.new input
  end

  let(:input) do
    <<~INPUT
      Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
      Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
      Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
      Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
      Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    INPUT
  end

  it 'should get games' do
    actual = exercise.games

    expect(actual.size).to be(5)
    expect(actual.first).to have_attributes(
      number: 1,
      rounds: [
        { blue: 3, red: 4 },
        { red: 1, green: 2, blue: 6 },
        { green: 2 }
      ]
    )
  end

  it 'should find valid games' do
    actual = exercise.valid_games

    expect(actual.map(&:number)).to eq([1, 2, 5])
  end

  it 'should give checksum' do
    actual = exercise.checksum

    expect(actual).to be(8)
  end
end
