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
    expect(exercise.get_value(exercise.engine, 3, 1)).to eq('*')
    expect(exercise.neighbors(exercise.engine, 3, 1)).to contain_exactly(
      '.', '.', '.', '5', '3', '.', '7', '.'
    )

    expect(exercise.get_value(exercise.engine, 0, 0)).to eq('4')
    expect(exercise.neighbors(exercise.engine, 0, 0)).to contain_exactly(
      '6', '.', '.'
    )

    expect(exercise.get_value(exercise.engine, 9, 9)).to eq('.')
    expect(exercise.neighbors(exercise.engine, 9, 9)).to contain_exactly(
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

  it 'should have normalized engine' do
    expect(exercise.normalized_engine.first).to eq(
      [467, 467, 467, nil, nil, 114, 114, 114, nil, nil]
    )
    expect(exercise.normalized_engine[1]).to eq(
      [nil, nil, nil, '*', nil, nil, nil, nil, nil, nil]
    )
  end

  it 'should find neighbors for gear' do
    expect(exercise.get_value(exercise.normalized_engine, 3, 1)).to eq('*')
    expect(exercise.unique_neighbors(exercise.normalized_engine, 3, 1)).to contain_exactly(
      467, 35
    )
  end

  it 'should return gears' do
    expect(exercise.gears).to eq(
      [
        [35, 467],
        [755, 598]
      ]
    )
  end

  it 'should return gear ratios' do
    expect(exercise.gear_ratios).to eq(
      [16_345, 451_490]
    )
  end

  it 'should return gear ratio checksum' do
    expect(exercise.gear_ratio_checksum).to eq(467_835)
  end
end
