require_relative 'day03'

RSpec.describe Day03 do
  let(:exercise) do
    described_class.new input
  end

  let(:input) do
    <<~INPUT
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
    INPUT
  end

  it 'should match digit' do
    expect(exercise.digit?('0')).to be_truthy
    expect(exercise.digit?('9')).to be_truthy
    expect(exercise.digit?('a')).to be_falsey
    expect(exercise.digit?('.')).to be_falsey
  end

  it 'should match symbol' do
    expect(exercise.symbol?('.')).to be_falsey
    expect(exercise.symbol?('9')).to be_falsey
    expect(exercise.symbol?('*')).to be_truthy
    expect(exercise.symbol?('$')).to be_truthy
    expect(exercise.symbol?('&')).to be_truthy
    expect(exercise.symbol?('*')).to be_truthy
    expect(exercise.symbol?('-')).to be_truthy
  end

  it 'should find neighbors' do
    expect(exercise.get_value(3, 1)).to eq('*')
    expect(exercise.neighbors(3, 1)).to contain_exactly(
      '.', '.', '.', '5', '3', '.', '7', '.'
    )

    expect(exercise.get_value(0, 0)).to eq('4')
    expect(exercise.neighbors(0, 0)).to contain_exactly(
      '6', '.', '.'
    )

    expect(exercise.get_value(9, 9)).to eq('.')
    expect(exercise.neighbors(9, 9)).to contain_exactly(
      '.', '.', '.'
    )
  end

  context 'with weird input' do
    let(:input) do
      <<~INPUT
        .....
        .882.
        *....
      INPUT
    end

    it 'should find match' do
      expect(exercise.parts).to include(882)
    end
  end

  it 'should return parts' do
    expect(exercise.parts).to include(
      467,
      35,
      633,
      617,
      592,
      755,
      664,
      598
    )
  end

  it 'should have sum' do
    expect(exercise.sum).to eq(4361)
  end
end
