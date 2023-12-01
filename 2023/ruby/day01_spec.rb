require_relative 'day01'

RSpec.describe Day01 do
  let(:exercise) do
    described_class.new input
  end

  let(:input) do
    <<~INPUT
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
    INPUT
  end

  it 'should extract numbers' do
    actual = exercise.numbers

    expect(actual).to contain_exactly(
      12, 38, 15, 77
    )
  end

  it 'should provide checksum' do
    actual = exercise.checksum

    expect(actual).to be(142)
  end
end
