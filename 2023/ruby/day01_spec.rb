require_relative 'day01'

RSpec.describe Day01 do
  context 'part 1' do
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

  context 'part 2' do
    let(:exercise) do
      described_class.new input
    end

    let(:input) do
      <<~INPUT
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen
      INPUT
    end

    it 'should extract numbers' do
      actual = exercise.numbers

      expect(actual).to contain_exactly(
        29, 83, 13, 24, 42, 14, 76
      )
    end

    it 'should provide checksum' do
      actual = exercise.checksum

      expect(actual).to be(281)
    end

    it 'should handle overlap' do
      actual = described_class.new('eighthree').numbers
      expect(actual).to contain_exactly(83)

      actual = described_class.new('sevenine').numbers
      expect(actual).to contain_exactly(79)
    end
  end
end
