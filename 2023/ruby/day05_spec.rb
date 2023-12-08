require_relative 'day05'

RSpec.describe Day05 do
  let(:exercise) do
    described_class.new input
  end

  let(:input) do
    <<~INPUT
      seeds: 79 14 55 13

      seed-to-soil map:
      50 98 2
      52 50 48

      soil-to-fertilizer map:
      0 15 37
      37 52 2
      39 0 15

      fertilizer-to-water map:
      49 53 8
      0 11 42
      42 0 7
      57 7 4

      water-to-light map:
      88 18 7
      18 25 70

      light-to-temperature map:
      45 77 23
      81 45 19
      68 64 13

      temperature-to-humidity map:
      0 69 1
      1 0 69

      humidity-to-location map:
      60 56 37
      56 93 4
    INPUT
  end

  it 'should parse seeds' do
    expect(exercise.seeds).to eq(
      [79, 14, 55, 13]
    )
  end

  it 'should parse maps' do
    first_map = exercise.maps.first
    expect(first_map.source).to eq(
      'seed'
    )
    expect(first_map.dest).to eq(
      'soil'
    )
  end

  it 'should have mappings' do
    first_map = exercise.maps.first

    expect(first_map.mappings[0]).to eq([98..100, -48])
    expect(first_map.mappings[1]).to eq([50..98, 2])
  end

  it 'should be able to lookup locations' do
    first_map = exercise.maps.first

    expect(first_map.lookup(79)).to eq(81)
    expect(first_map.lookup(14)).to eq(14)
    expect(first_map.lookup(55)).to eq(57)
    expect(first_map.lookup(13)).to eq(13)
  end

  it 'should find locations' do
    expect(exercise.find_location(79)).to eq(82)
    expect(exercise.find_location(14)).to eq(43)
    expect(exercise.find_location(55)).to eq(86)
    expect(exercise.find_location(13)).to eq(35)
  end

  it 'should find lowest location' do
    expect(exercise.lowest_location).to eq(35)
  end

  it 'should lookup range' do
    first_map = exercise.maps.first

    expect(first_map.lookup_range(79..93)).to eq(
      [81..95]
    )

    expect(first_map.lookup_range(55..68)).to eq(
      [57..70]
    )

    expect(first_map.lookup_range(102..104)).to eq(
      [102..104]
    )
  end

  it 'should find lowest location ranges' do
    expect(exercise.lowest_location_ranges).to eq(46)
  end
end
