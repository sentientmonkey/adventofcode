require_relative 'day06'

RSpec.describe Day06 do
  let(:exercise) do
    described_class.new input
  end

  let(:input) do
    <<~INPUT
      Time:      7  15   30
      Distance:  9  40  200
    INPUT
  end

  it 'can parse times and distances' do
    expect(exercise.times).to contain_exactly(
      7, 15, 30
    )
    expect(exercise.distances).to contain_exactly(
      9, 40, 200
    )
  end

  it 'can find results for races' do
    expect(exercise.races.first).to contain_exactly(
      2, 3, 4, 5
    )
  end

  it 'can find ways to win' do
    expect(exercise.ways_to_win).to contain_exactly(
      4, 8, 9
    )
  end

  it 'can get win product' do
    expect(exercise.win_product).to eq(288)
  end
end
